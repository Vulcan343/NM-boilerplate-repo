from flask import Blueprint, request, jsonify, make_response
import json
from src import db


inventory = Blueprint('inventory', __name__)

# route to get the entire stock of the company
@inventory.route('/inventory', methods=['GET'])
def get_inventory():

    cursor = db.get_db().cursor()
    cursor.execute('select * from Inventory')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get specific store location inventory information
@inventory.route('/inventory/<storeID>', methods=['GET'])
def get_store_location(storeID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Inventory where storeID = {0}'.format(storeID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# get specific product information from the inventory
@inventory.route('/inventory/<productID>', methods=['GET'])
def get_products_from_inv(productID):
    cursor = db.get_db().cursor()
    cursor.execute('select * from Inventory where productID = {0}'.format(productID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

