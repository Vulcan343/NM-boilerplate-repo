from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


products = Blueprint('products', __name__)

# Get all the products from the database
@products.route('/products', methods=['GET'])
def get_products():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products

    cursor.execute('SELECT name, price, milk_type, productID FROM Products')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in 
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers. 
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    return jsonify(json_data)


@products.route('/postproducts/try', methods=['POST'])
def post_products():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    prod_name = req_data["product_name"]
    prod_price = req_data["price"]
    prod_type = req_data["milk_type"]
    prod_ID = req_data["productID"]

    insert_stmt = f'INSERT INTO Products (name, price, milk_type, productID) ' \
                  f'VALUES ("{prod_name}", {prod_price}, "{prod_type}", {prod_ID})'

    current_app.logger.info(insert_stmt)

    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Yasssss"


@products.route('/products/<productID>', methods=['GET'])
def get_prod_info(productID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products where ID = requested ID
    cursor.execute(f'SELECT * FROM Products where productID = {productID}')

    # grab the column headers from the returned data
    column_headers = [x[0] for x in cursor.description]

    # create an empty dictionary object to use in
    # putting column headers together with data
    json_data = []

    # fetch all the data from the cursor
    theData = cursor.fetchall()

    # for each of the rows, zip the data elements together with
    # the column headers.
    for row in theData:
        json_data.append(dict(zip(column_headers, row)))

    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'

    return the_response

# update the inforomation about a specific product
@products.route('/products/update/<productID>', methods=['PUT'])
def update_product_info(productID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    prod_name = req_data['ProdName']
    prod_price = req_data['prodprice']
    prod_type = req_data['milk_type']
   # prod_ID = req_data['productID']


    update_stmt = f'UPDATE Products ' \
                  f'SET name = "{prod_name}", price = {prod_price}, milk_type = "{prod_type}" ' \
                  f'WHERE productID = {productID}'

    current_app.logger.info(update_stmt)

    cursor.execute(update_stmt)
    db.get_db().commit()
    return "Yasssss"
