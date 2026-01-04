package com.nilecare.exception;

/**
 * Exception thrown when a user attempts to log in with a deactivated account
 */
public class AccountDisabledException extends RuntimeException {
    public AccountDisabledException(String message) {
        super(message);
    }
}
