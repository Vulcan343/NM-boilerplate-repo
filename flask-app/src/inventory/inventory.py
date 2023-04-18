from flask import Blueprint, request, jsonify, make_response
import json
from src import db


inventory = Blueprint('inventory', __name__)