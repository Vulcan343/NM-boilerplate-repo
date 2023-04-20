from flask import Blueprint, request, jsonify, make_response
import json
from src import db


inventory = Blueprint('inventory', __name__)

# route to get the entire stock of the company
@inventory.route('/inventory', methods=['GET'])
def get_inventory():

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for all contents of inventory
    cursor.execute('select * from Inventory')

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


# Get specific store location inventory information
@inventory.route('/inventory/store/<storeID>', methods=['GET'])
def get_store_location(storeID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of inventory contents in a specific store
    cursor.execute('select * from Inventory where storeID = {0}'.format(storeID))

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

# get specific product information from the inventory
@inventory.route('/inventory/<productID>', methods=['GET'])
def get_products_from_inv(productID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of one product's appearances across all stores' inventories
    cursor.execute('select * from Inventory where productID = {0}'.format(productID))

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

