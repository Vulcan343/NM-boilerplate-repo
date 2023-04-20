from flask import Blueprint, request, jsonify, make_response, current_app
import json
from src import db


employee = Blueprint('employee', __name__)

# route to get the entire group of employees within in the company
@employee.route('/employee', methods=['GET'])
def get_employees():

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for list of all employees
    cursor.execute('select * from Employees')

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


# Get specific employee information
@employee.route('/employee/<employeeID>', methods=['GET'])
def get_employee(employeeID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    cursor.execute(f'select * from Employees where employeeID = "{employeeID}"')

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

# Get all employees who work at specific locations 
@employee.route('/employee/stores/<storeID>', methods=['GET'])
def get_employees_at_store_loc(storeID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for all employee information from one store
    cursor.execute(f'select * from Employees where home_store = {storeID}')

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
    employeeID = req_data['EmployeeID']
    hourly_wage = req_data['Hourly_Wage']
    home_store = req_data['Store_Location']

    insert_stmt = f'INSERT INTO Employees (first_name, last_name, SSN, employeeID, hourly_wage, home_store) ' \
                  f'VALUES ("{first_name}", "{last_name}", {SSN}, "{employeeID}", {hourly_wage}, {home_store})'

    current_app.logger.info(insert_stmt)

    cursor.execute(insert_stmt)
    db.get_db().commit()
    return "Yasssss"

@employee.route('/yourefired', methods=['DELETE'])
def remove_employee(empID):

    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to delete specific employee with requested ID
    query = f'''
            DELETE *
            FROM Employees
            WHERE employeeID = {empID}
        '''
    cursor.execute(query)
    db.get_db().commit()

    return 'Yassss'


# update the inforomation about a specific employee
@employee.route('/employee/update/<employeeID>', methods=['PUT'])
def update_product_info(employeeID):
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    current_app.logger.info('Processing form data')
    req_data = request.get_json()
    current_app.logger.info(req_data)

    first_name = req_data['first_nameCopy']
    last_name = req_data['last_nameCopy']
    hourly_wage = req_data['Hourly_WageCopy']
    home_store = req_data['Store_LocationCopy']
    empID = req_data['EmployeeIDCopy']

    update_stmt = f'UPDATE Employees ' \
                  f'SET first_name = "{first_name}", last_name = "{last_name}", hourly_wage = {hourly_wage}, home_store = {home_store} ' \
                  f'WHERE employeeID = "{empID}"'

    current_app.logger.info(update_stmt)

    cursor.execute(update_stmt)
    db.get_db().commit()
    return "Yasssss"

