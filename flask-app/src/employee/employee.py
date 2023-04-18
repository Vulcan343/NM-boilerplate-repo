from flask import Blueprint, request, jsonify, make_response
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
    cursor.execute('select * from Employees where employeeID = {0}'.format(employeeID))
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
    cursor.execute('select * from Employees where storeID = {0}'.format(storeID))
    row_headers = [x[0] for x in cursor.description]
    json_data = []
    theData = cursor.fetchall()
    for row in theData:
        json_data.append(dict(zip(row_headers, row)))
    the_response = make_response(jsonify(json_data))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response