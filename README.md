# Superstore
This project consists of a Front-End written in React.JS, a back-end written in C#, and MS SQL Stored Procedures.

## Superstore API

### Address
- **GET** /api/addresses/{id}
- **POST** /api/addresses
- **PUT** /api/addresses/{id}
- **DELETE** /api/addresses/{id}

### Product
- **GET** /api/products
- **GET** /api/products/{id}
- **POST** /api/products
- **PUT** /api/products/{id}
- **DELETE** /api/products/{id}

### Customer
- **GET** /api/customers
- **GET** /api/customers/{id}
- **GET** /api/customers/{id}/addresses
- **GET** /api/customers/{id}/orders
- **POST** /api/customers
- **PUT** /api/customers/{id}
- **DELETE** /api/customers/{id}

### Order
- **GET** /api/orders
- **GET** /api/orders/{id}
- **GET** /api/orders/{id}/orderdetails
- **POST** /api/orders
- **PUT** /api/orders/{id}
- **DELETE** /api/orders/{id}

### AddressType (Lookup Table)
- **GET** /api/addresstypes

### Region (Lookup Table)
- **GET** /api/regions

### Segment (Lookup Table)
- **GET** /api/segments

### ShipMode (Lookup Table)
- **GET** /api/shipmodes

### Category (Lookup Table)
- **GET** /api/categories

### Country (Lookup Table)
- **GET** /api/countries

### State (Lookup Table)
- **GET** /api/states

### SubCategory (Lookup Table)
- **GET** /api/subcategories
