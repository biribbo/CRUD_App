package com.example.crudApp.exception;

public class InvalidPageNumberException extends RuntimeException {
    public InvalidPageNumberException(String message) {
        super(message);
    }
}
