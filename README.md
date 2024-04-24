# Product Management System

This is a full-stack application built to manage products, comments, users, and categories. The backend is developed using Spring Boot, while the frontend is built with Flutter. The project includes various functionalities, each categorized based on its complexity level.

## Features

- **Product Management**: CRUD operations for products including adding, deleting (using the `isDeleted` flag), editing, and listing with pagination.
- **Product Comments**: CRUD operations for comments related to products, including adding, editing, deleting, and listing. Each product can have multiple comments.
- **Product Pagination**: Server-side pagination for listing products.
- **Product Filtering**: Search products by name on the server-side. Enter a keyword to find all products whose name contains the given keyword.
- **User Authentication/Registration**: User authentication and registration using tokens.
- **User Roles**: Two user roles implemented - admin and regular user. Views are role-dependent; only admins can delete products, while regular users cannot delete any products, even their own.
- **User Management**: Edit users and assign roles. Admins can change user roles.
- **Product Categories**: CRUD operations for categories, including adding, editing, deleting, and listing without pagination. Each product can belong to multiple categories, and a category can contain multiple products.
- **Product Filtering by Category**: Select a category and get products in that category.

## Technologies Used

- **Backend**: Spring Boot
- **Frontend**: Flutter

## Usage
- Access the backend API endpoints to perform CRUD operations on products, comments, users, and categories.
- Use the Flutter app to interact with the frontend and access the various functionalities provided by the system.
