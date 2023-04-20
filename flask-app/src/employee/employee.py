from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


employee = Blueprint('employee', __name__)

# route to get the entire group of employees within in the company
@employee.route('/employee', methods=['GET'])
def get_employees():
    cursor = db.get_db().cursor()
    cursor.execute('select * from Employees')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response


# Get specific employee information
@employee.route('/employee/<employeeID>', methods=['GET'])
def get_employee(employeeID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from Employees where employeeID = {employeeID}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get all employees who work at specific locations 
@employee.route('/employee/<storeID>', methods=['GET'])
def get_employees_at_store_loc(storeID):
    cursor = db.get_db().cursor()
    cursor.execute(f'select * from Employees where storeID = {storeID}')
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

#post a new employee within the system
@employee.route('/employee/newhire', methods=['POST'])
def post_employee():
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    last_name = req_data['last_name']
    first_name = req_data['first_name']
    SSN = req_data['SSN']
    employeeID = req_data['employeeID']
    hourly_wage = req_data['hourly_wage']
    home_store = req_data['home_store']

    insert_stmt = f'INSERT INTO Employees (first_name, last_name, SSN, employeeID, hourly_wage, home_store) ' \
                  f'VALUES ({first_name}, {last_name}, {SSN}, {employeeID}, {hourly_wage}, {home_store})'

    current_app.logger.info(insert_stmt)

    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Yasssss"

@employee.route('/yourefired', methods=['DELETE'])
def remove_employee(empID):
    cursor = db.get_db().cursor()
    query = f'''
            DELETE *
            FROM Employees
            WHERE employeeID = {empID}
        '''
    cursor.execute(query)
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


# update the inforomation about a specific employee
@employee.route('/employee/update/<employeeID>', methods=['PUT'])
def update_product_info(employeeID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    first_name = req_data['first_name']
    last_name = req_data['last_name']
    hourly_wage = req_data['hourly_wage']
    home_store = req_data['home_store']
    empID = req_data['employeeID']

    update_stmt = f'UPDATE (first_name, last_name, hourly_wage, home_store) ' \
                  f'SET ({first_name}, {last_name}, {hourly_wage})' \
                  f'WHERE employeeID = {empID}'

    current_app.logger.info(update_stmt)

    cursor.execute(update_stmt)
    db.get_db().commit()
    return "Yasssss"

