from flask import Blueprint, request, jsonify, make_response
import json
from src import db


employee = Blueprint('employee', __name__)