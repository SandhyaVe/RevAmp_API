package org.Token_Extraction;


import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.openqa.selenium.support.ui.ExpectedConditions;
import io.github.bonigarcia.wdm.WebDriverManager;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.util.Set;

public class TokenExtractorUtil {

    private static final String APP_LOGIN_URL = "https://qa.revamprcm.com/login";
    private static final String APP_BASE_URL = "https://qa.revamprcm.com";
    private static final String API_GATEWAY_URL = "https://mttd2k3khk.execute-api.us-east-1.amazonaws.com/qa";
    private static final String DEBUG_LOG = "target/token-extractor-debug.log";

    public static String getAuthCookie(String email, String password) {
        resetDebugLog();
        log("========== TokenExtractorUtil started ==========");
        log("Headless mode: " + isHeadless());

        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        if (isHeadless()) {
            options.addArguments("--headless=new");
        }
        options.addArguments("--disable-gpu", "--window-size=1920,1080", "--disable-dev-shm-usage", "--no-sandbox");

        WebDriver driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));

        String cookieValue = null;
        try {
            driver.get(APP_LOGIN_URL);
            logPage(driver, "Opened login page");

            WebElement emailField = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("mat-input-0")));
            emailField.sendKeys(email);

            WebElement loginButton = wait.until(ExpectedConditions.elementToBeClickable(
                    By.xpath("//button[@class='mdc-button mdc-button--raised mat-mdc-raised-button mat-unthemed mat-mdc-button-base']")));
            loginButton.click();
            logPage(driver, "Clicked app login button");

            enterPasswordAndVerify(driver, wait, password);
            clickMicrosoftButton(driver, wait, "Microsoft sign-in button");
            Thread.sleep(1500);

            if (isPasswordRequired(driver)) {
                log("Microsoft validation says password is required. Retrying password entry once...");
                enterPasswordAndVerify(driver, wait, password);
                clickMicrosoftButton(driver, wait, "Microsoft sign-in button after password retry");
                Thread.sleep(2000);
            }

            handleStaySignedInPrompt(driver);

            wait.until(d -> d.getCurrentUrl().contains("qa.revamprcm.com")
                    || d.getCurrentUrl().contains("execute-api.us-east-1.amazonaws.com"));
            logPage(driver, "Returned from Microsoft login flow");

            // Wait for the page to fully load and cookie to be set
            Thread.sleep(5000);

            // First try: check cookies on the current domain (qa.revamprcm.com)
            dumpCookies(driver, "current domain after login redirect");
            Cookie authCookie = driver.manage().getCookieNamed("auth_token");
            if (authCookie != null) {
                cookieValue = authCookie.getValue();
                log("Extracted auth_token from current domain: " + mask(cookieValue) + ", length=" + cookieValue.length());
            } else {
                // The auth_token cookie is set on the API Gateway domain, not qa.revamprcm.com
                // Navigate to the API Gateway domain to access its cookies
                log("auth_token not found on current domain, checking API Gateway domain...");
                driver.get(API_GATEWAY_URL);
                Thread.sleep(2000);
                logPage(driver, "Opened API Gateway domain");
                dumpCookies(driver, "API Gateway domain");

                authCookie = driver.manage().getCookieNamed("auth_token");
                if (authCookie != null) {
                    cookieValue = authCookie.getValue();
                    log("Extracted auth_token from API Gateway domain: " + mask(cookieValue) + ", length=" + cookieValue.length());
                } else {
                    // Fallback: try to get all cookies and find auth_token
                    Set<Cookie> allCookies = driver.manage().getCookies();
                    for (Cookie cookie : allCookies) {
                        if (cookie.getName().equals("auth_token")) {
                            cookieValue = cookie.getValue();
                            log("Found auth_token via cookie iteration: " + mask(cookieValue) + ", length=" + cookieValue.length());
                            break;
                        }
                    }
                }

                // Final fallback: try localStorage on the original app
                if (cookieValue == null) {
                    log("WARNING: auth_token cookie not found on either domain. Trying localStorage fallback on app domain...");
                    driver.get(APP_BASE_URL);
                    Thread.sleep(1000);
                    logPage(driver, "Opened app base for localStorage fallback");
                    JavascriptExecutor js = (JavascriptExecutor) driver;
                    cookieValue = (String) js.executeScript("return window.localStorage.getItem('auth_token');");
                    if (cookieValue != null) {
                        log("Fallback found auth_token in localStorage: " + mask(cookieValue) + ", length=" + cookieValue.length());
                    }
                }
            }

            if (cookieValue == null || cookieValue.isBlank()) {
                log("AUTH_COOKIE_RESULT: NULL/EMPTY");
                takeScreenshot(driver, "target/token-extractor-failure.png");
            } else {
                log("AUTH_COOKIE_RESULT: SUCCESS " + mask(cookieValue) + ", length=" + cookieValue.length());
            }

        } catch (Exception e) {
            log("AUTH_COOKIE_EXCEPTION: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            try {
                logPage(driver, "Exception state");
                takeScreenshot(driver, "target/token-extractor-exception.png");
            } catch (Exception ignored) {
                log("Unable to capture exception page details: " + ignored.getMessage());
            }
        } finally {
            driver.quit();
            log("========== TokenExtractorUtil finished ==========");
        }
        return cookieValue;
    }

    private static boolean isHeadless() {
        return Boolean.parseBoolean(System.getProperty("tokenExtractor.headless", "true"));
    }

    private static void enterPasswordAndVerify(WebDriver driver, WebDriverWait wait, String password) {
        WebElement passwordField = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector("input#i0118, input[name='passwd'], input[type='password']")));

        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView({block:'center'});", passwordField);
        passwordField.click();
        passwordField.sendKeys(Keys.chord(Keys.CONTROL, "a"));
        passwordField.sendKeys(Keys.DELETE);
        passwordField.sendKeys(password);

        String enteredValue = passwordField.getAttribute("value");
        if (enteredValue == null || enteredValue.isEmpty()) {
            log("Password field value was empty after sendKeys. Trying JavaScript input fallback...");
            ((JavascriptExecutor) driver).executeScript(
                    "arguments[0].value = arguments[1];"
                            + "arguments[0].dispatchEvent(new Event('input', { bubbles: true }));"
                            + "arguments[0].dispatchEvent(new Event('change', { bubbles: true }));",
                    passwordField,
                    password);
            enteredValue = passwordField.getAttribute("value");
        }

        if (enteredValue == null || enteredValue.isEmpty()) {
            throw new IllegalStateException("Password was not entered into Microsoft password field");
        }
        log("Password field populated successfully. length=" + enteredValue.length());
    }

    private static void clickMicrosoftButton(WebDriver driver, WebDriverWait wait, String description) {
        WebElement button = wait.until(ExpectedConditions.elementToBeClickable(By.id("idSIButton9")));
        button.click();
        logPage(driver, "Clicked " + description);
    }

    private static boolean isPasswordRequired(WebDriver driver) {
        String pageSource = driver.getPageSource();
        return pageSource != null && pageSource.toLowerCase().contains("please enter your password");
    }

    private static void handleStaySignedInPrompt(WebDriver driver) throws InterruptedException {
        try {
            WebDriverWait shortWait = new WebDriverWait(driver, Duration.ofSeconds(10));
            shortWait.until(d -> {
                String source = d.getPageSource();
                String currentUrl = d.getCurrentUrl();
                return currentUrl.contains("qa.revamprcm.com")
                        || currentUrl.contains("execute-api.us-east-1.amazonaws.com")
                        || (source != null && source.toLowerCase().contains("stay signed in"));
            });

            String source = driver.getPageSource();
            if (source != null && source.toLowerCase().contains("stay signed in")) {
                WebElement yesButton = shortWait.until(ExpectedConditions.elementToBeClickable(By.id("idSIButton9")));
                yesButton.click();
                log("Clicked optional Microsoft stay-signed-in prompt.");
                Thread.sleep(1500);
                logPage(driver, "After stay-signed-in prompt");
            } else {
                log("Stay-signed-in prompt not shown; continuing.");
            }
        } catch (TimeoutException e) {
            log("Stay-signed-in prompt not detected within timeout; continuing. Current URL=" + driver.getCurrentUrl());
        }
    }

    private static void dumpCookies(WebDriver driver, String label) {
        Set<Cookie> cookies = driver.manage().getCookies();
        log("Cookies on " + label + ": count=" + cookies.size());
        for (Cookie cookie : cookies) {
            String value = cookie.getValue() == null ? "null" : mask(cookie.getValue());
            log("Cookie name=" + cookie.getName()
                    + ", domain=" + cookie.getDomain()
                    + ", path=" + cookie.getPath()
                    + ", httpOnly=" + cookie.isHttpOnly()
                    + ", secure=" + cookie.isSecure()
                    + ", value=" + value);
        }
    }

    private static void logPage(WebDriver driver, String label) {
        log(label + " | url=" + driver.getCurrentUrl() + " | title=" + driver.getTitle());
    }

    private static void takeScreenshot(WebDriver driver, String path) {
        try {
            File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            File target = new File(path);
            File parent = target.getParentFile();
            if (parent != null) {
                parent.mkdirs();
            }
            Files.copy(screenshot.toPath(), target.toPath(), StandardCopyOption.REPLACE_EXISTING);
            log("Screenshot saved: " + target.getAbsolutePath());
        } catch (Exception e) {
            log("Unable to capture screenshot: " + e.getMessage());
        }
    }

    private static String mask(String value) {
        if (value == null) {
            return "null";
        }
        if (value.length() <= 20) {
            return value;
        }
        return value.substring(0, 12) + "..." + value.substring(value.length() - 8);
    }

    private static void resetDebugLog() {
        File debugLog = new File(DEBUG_LOG);
        File parent = debugLog.getParentFile();
        if (parent != null) {
            parent.mkdirs();
        }
        try (FileWriter writer = new FileWriter(debugLog, false)) {
            writer.write("");
        } catch (IOException ignored) {
            // If the debug log cannot be reset, continue and still print to console.
        }
    }

    private static void log(String message) {
        String line = "[TokenExtractor] " + message;
        System.out.println(line);
        try (FileWriter writer = new FileWriter(DEBUG_LOG, true)) {
            writer.write(line + System.lineSeparator());
        } catch (IOException ignored) {
            // Keep console logging even if file logging fails.
        }
    }
}
