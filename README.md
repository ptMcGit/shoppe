# Ye Olde Shoppe

Let's suppose we have a storefront. Included in this repo are files containing our transaction history for the last month (`./data/transactions.json`) and our inventory and user lists (`./data/data.json`). Our goal is to run some analytics on those.

1. Write classes to get the included tests (`./tests.rb`) passing
1. Feel free to write more tests as you like to add more functionality to your classes
1. Use those classes to answer the following questions (and update this README)

## Stats

* The user that made the most orders was __             Ms. Maxwell Gaylord
* We sold __ Ergonomic Rubber Lamps                     31
* We sold __ items from the Tools category              198
* Our total revenue was __                              $65,696.65
* Harder: the highest grossing category was __          books $14,619.40

## Background

If you're curious, you can see the script used to generate our dummy data in `./generators`

## Implementation

Modify/implement the project in a way such that the original tests still pass.

### 1

- Toss out invalid files i.e. transaction files that use 3 pairs instead of 4
- Identify the correct parser for a given file
- Create an array of the parsed files
- Create databases of "like data", and add those dbs to an array

### 2

- Create a set of queries specific to each type of database that return "tables" to a table array
- Use those queries to answer questions
