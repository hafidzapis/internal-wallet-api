# Wallet Transaction System API

This project implements an internal wallet transactional system API. The goal is to enable money transfers and withdrawals between entities such as User, Team, Stock, or any other, each having its defined "wallet."
## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Tests](#tests)
- [Contributing](#contributing)
- [License](#license)

## Introduction

The API facilitates internal money transfers and withdrawals between entities with their dedicated wallets. Each transaction is recorded in the database, adhering to ACID standards.

## Features

- Wallet System: Entities (User, Team, Stock, etc.) have their designated wallets for money transactions.

- Credit/Debit Transactions: Requests for credit/debit (deposit or withdraw) are based on records in the database.

- Validations: Proper validations are implemented for every transaction, ensuring required fields and valid source/target wallets.

- Database Transactions: Each transaction is created using database transactions for data consistency.

- Balance Calculation: Wallet balances for each entity are calculated by summing up relevant records.

- User Authentication: Custom sign-in solution without any external gem, providing session management.

- Latest Stock Price Library: A library in the "gem style" is implemented in the lib folder for retrieving stock prices.

## Architecture

The wallet solution follows a generic design for money manipulation between entities, utilizing design patterns like Single Table Inheritance (STI) for efficient money handling.

## Database Transactions

Transactions adhere to ACID standards, providing consistency and reliability in the database.

## Balance Calculation
Wallet balances are dynamically calculated by summing relevant transaction records.

## User Authentication
Custom sign-in solution is implemented for session management without relying on external gems.

## Latest Stock Price Library
A LatestStockPrice library in the lib folder is created for endpoints such as "price," "prices," and "price_all."

## API Endpoints
- **POST /api/v1/login**: Log in to the system.
    - Parameters:
      - `user_name`: User's username.
      - `password`: User's password.


- **DEL /api/v1/logout**: Log out of the system.
    - `Headers`:
      Authorization: Bearer<token>


- **GET /api/v1/current_user**: Retrieve information about the current logged-in user.
    - `Headers`:
      Authorization: Bearer<token>



- **POST /api/v1/transfer/deposit**: Create a deposit transaction.
  - `Headers`:
  Authorization: Bearer<token>
  - Parameters:
      - `source_wallet_id`: ID of the source wallet.
      - `amount`: Amount to deposit.


- **POST /api/v1/transfer/withdrawal**: Create a withdrawal transaction.
  - `Headers`:
  Authorization: Bearer<token>
  - Parameters:
    - `source_wallet_id`: ID of the source wallet.
    - `amount`: Amount to withdraw.


- **POST /api/v1/transfer/create_transfer**: Create a fund transfer transaction.
  - `Headers`:
  Authorization: Bearer<token>
  - Parameters:
    - `source_wallet_id`: ID of the source wallet.
    - `target_wallet_id`: ID of the target wallet.
    - `amount`: Amount to transfer.


- **GET /api/v1/stock/price**: Get the current price of a stock.
    - `Headers`:
      Authorization: Bearer<token>
    - Parameters:
        - `indices`: Stock indices.
        - `identifier`: Stock identifier.


- **GET /api/v1/stock/prices**: Get the current prices of stocks.
    - Parameters:
        - `indices`: Stock indices.
        - `identifier`: Stock identifier.


- **GET /api/v1/stock/price_all**: Get the prices of all stocks.
    - `Headers`:
      Authorization: Bearer<token>
    - Parameters:
        - `identifier`: Stock identifier.


- **POST /api/v1/wallet/create**: Create a wallet for an entity.
    - `Headers`:
      Authorization: Bearer<token>
    - Parameters:
        - None.


- **GET /api/v1/wallet/balance**: Get the balance and transaction history of the current user's wallet.
    - `Headers`:
      Authorization: Bearer<token>
    - Parameters:
        - None.

## Running 
1. Running Test 

   ```bash
   bundle exec rspec

2. Running Project

    Install dependency by using 
    
       ```bash
       bundle install
