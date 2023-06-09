from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


customers = Blueprint('customers', __name__)

# Get all customers from the DB
@customers.route('/customers', methods=['GET'])
def get_customers():
    # get a cursor object from the database
    cursor = db.get_db().cursor()
    # use cursor to query the database for a list of products where ID = requested ID
    cursor.execute('select customer_id, last_name,\
        first_name, email, primary_store_id from Customers')


    # grab the column headers from the returned data
    row_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers.
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get customer detail for customer with particular userID
@customers.route('/customers/<customerID>', methods=['GET'])
def get_customer(customerID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    cursor.execute('select * from Customers where customer_id = {0}'.format(customerID))

    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#remove a customer from the customer table
@customers.route('/forlegalreasons/<custID>', methods=['DELETE'])
def remove_customer(custID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    query = f'DELETE FROM Customers WHERE customer_id = {custID}'
    current_app.logger.info(query)
    cursor.execute(query)
    db.get_db().commit()
    # grab the column headers from the returned data    

    return 'Yasss'