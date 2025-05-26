from Google import Create_Service # download source from the link in the description
import pandas as pd

def run_batchUpdate_request(service, google_sheet_id, request_body_json):
    try:
        response = service.spreadsheets().batchUpdate(
            spreadsheetId=google_sheet_id,
            body=request_body_json
        ).execute()
        return response
    except Exception as e:
        print(e)
        return None

import os
from Google import Create_Service

CLIENT_SECRET_FILE = 'credentials.json'
API_SERVICE_NAME = 'sheets'
API_VERSION = 'v4'
SCOPES = ['https://www.googleapis.com/auth/spreadsheets']
GOOGLE_SHEET_ID = '1uiN0RQ9KOL9n4ewuJnMwLdmmYhkBxKiO2DqNgG1L5cg'

service = Create_Service(CLIENT_SECRET_FILE, API_SERVICE_NAME, API_VERSION, SCOPES)

"""
Iterate Worksheets
"""
gsheets = service.spreadsheets().get(spreadsheetId=GOOGLE_SHEET_ID).execute()
sheets = gsheets['sheets']

for sheet in sheets:
    if sheet['properties']['title'] != 'master':
        dataset = service.spreadsheets().values().get(
            spreadsheetId=GOOGLE_SHEET_ID,
            range=sheet['properties']['title'],
            majorDimension='ROWS'
        ).execute()
        df = pd.DataFrame(dataset['values'])
        df.columns = df.iloc[0]
        df.drop(df.index[0], inplace=True)
        df.to_csv(sheet['properties']['title'] + '.csv', index=False)