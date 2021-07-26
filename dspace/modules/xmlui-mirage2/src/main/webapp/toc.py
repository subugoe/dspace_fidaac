#!/usr/bin/env python
# -*- encoding: utf-8 -*

# Skript erstellt Heftnavigation
# Übergeben wird: path_to_working_directory handle[Zahl]
# Daten: Item-Handle; Autor/innen; Titel; Seiten von; Seiten bis

# TODO: mehr als 100 Einträge per Rest abrufen

# rest_url = 'https://mediarep.org/rest/'
# rest/communities/{communityId}/collections - Returns an array of collections of the specified community
# rest/collections/{collectionId}/items - Return all items of the specified collection
# rest/items/{item id}/metadata - Return metadata of the specified item.

# Importe
import requests, os, sys, json


# FUNKTIONEN

def authenticate_session_rest(email, password, rest_url='https://thestacks.libaac.de/rest/'):
    """"
    Authenticate user via REST and return session if authentication is successful.
    If not exit execution.

    Parameters:
    -----------
        email, password, rest_url ='https://mediarep.org/rest/'

    Documentation:
    --------------
        https://wiki.lyrasis.org/display/DSDOC6x/REST+API
    """

    # Initiate Session
    import requests, sys
    session = requests.Session()
    data = {"email": email, "password": password}

    # Start Session
    login = session.post(rest_url + "login", data=data)

    # Check response
##    cookie_id = login.cookies.values()[0]
  ##  status = session.get(rest_url + "status", cookies = {"JSESSIONID":cookie_id}).text

 ##   if "<authenticated>true</authenticated>" in status:
 ##       return session
 ##   else:
 ##       sys.exit("Unable to authenticate.")
        
        
def get_value(keyname, data):
    """
    z.B. keyname = 'dc.subject', data = json() /// übergibt Liste
    """
    out = list(value for value in data if value['key'] == keyname)
    return [v['value'] for v in out]

def make_name_string(key, metadata):
    """
    transforms "Kafka, Franz" -> "Franz Kafka"
    returns string of names separated by '; ' [mary shelly; franz kafka]
    key is 'dc.creator' or 'dc.contributor.editor'
    """
    list_of_authors = get_value(key, metadata)
    new_name_list = []

    for name in list_of_authors:
        if "," in name:
           vn = name.split(",")[1].strip() + " " + name.split(",")[0].strip()
           new_name_list.append(vn)
        else:
            new_name_list.append(name)

    return "; ".join(new_name_list)

def get_all_metadata(rest_url, item_handles):
    """
    fragt Metadaten per REST ab,
    erstellt DataFrame
    """
    import pandas as pd
    metadata_list = []

    for h in item_handles:
        print(rest_url)
	print(h)
	metadata = requests.get(rest_url + 'handle/' + h + '?expand=metadata').json()['metadata']

        item_uri = get_value('dc.identifier.uri', metadata)[0] 
        title = get_value('dc.title', metadata)[0]

        # Abfrage: Welcher Dokumenttyp liegt vor?
        doctype = get_value('dc.type', metadata)[0]
        if doctype in ['article', 'review']:


            # Test auf römische / numerische Seitenzahlen

            creators = make_name_string('dc.contributor.author', metadata)

            # Neue Werte werden an Metadaten-Liste angehängt
            metadata_list.append([item_uri, creators, title])

 
        else:
            print('Handle {h} von Typ {doctype} wurde übersprungen')

    # metadatenliste wird Pandas Dataframe. Werte werden nach spage sortiert
    metadata_columns=['dc.identifier.uri','dc.contributor.author','dc.title']
    dataframe = pd.DataFrame(metadata_list, columns = metadata_columns)
    ##dataframe.sort_values(['local.source.spage'], axis=0, ascending=True, inplace=True)

    return dataframe

## make_html: Heftnavigation erstellen // SAMMLUNG, collection
def make_html(rest_url, all_items):
    """
    erstellt Liste aller Items einer Sammlung (handle),
    ermittelt und sortiert Metadaten,
    erstellt HTML-Navigation,
    schreibt HTML in Datei (als Backup)
    """

    html_navigation = "<div class='list-group'>\n"
    html_a = "<a href='{0}' class='list-group-item list-group-item-action flex-column align-items-start' style='border-style:none;'><p class='mb-0 author' style='display:table-cell;border-bottom-style:solid;border-bottom-color:#cc0;border-bottom-width:0.3em;'>{1}</p><h5 class='mb-0' style='font-weight:bold;font-size:larger;'>{2}</h5></a>\n"

    # erstellt Liste aller Items (Aufsätze)
    item_handles = [v['handle'] for v in all_items]
    #  ermittelt und sortiert Metadaten (spage)
    dataframe = get_all_metadata(rest_url, item_handles)
    print('dataframe: ')
    print(dataframe)

    # erstellt HTML-Navigation : TO DO: Hier nach doctype unterscheiden?
    for index, row in dataframe.iterrows():
        url = row["dc.identifier.uri"]
	print('url: ')
        print(url)
        author = row["dc.contributor.author"].encode('utf-8')
	print('author: ')
        print(author)
        title = row["dc.title"].encode('utf-8')
	print('title: ')
        print(title)
	print('index: ')
        print(index)
	print('row: ')
        print(row)
	print('finished')
        html_navigation += html_a.format(url, author, title)

    html_navigation += "</div>"

    return html_navigation

# UPDATE PER REST # braucht authentifizierte Session!
def update_coll(session, rest_url, handle, html_navigation):
    """
    schreibt HTML in Sammlung (handle)
    benötigt durch Login authentifzierte Session
	"""
    import json
    headers = {'content-type':'application/json'}
    fehlerliste = []
    coll_metadata = requests.get(rest_url + '/handle/' + handle + '?expand=metadata')
    if coll_metadata.status_code != 200:
        print("Fehler in update_coll / GET")
        sys.exit(1)

    coll_data = coll_metadata.json()
    coll_data['sidebarText'] = html_navigation

    # Update Collection Object
    collectionId = coll_data.get('uuid')
    coll_put = session.put(rest_url + "/collections/" + collectionId, data = json.dumps(coll_data), headers = headers)
    if coll_put.status_code != 200:
        print("Fehler in update_coll / PUT")
        sys.exit(1)
    else:
        print("Update von Sammlung " + coll_data['name'])

# MAIN-Funktion
def main(handle, email, password):
    import sys
    import requests
    import json

   
    
    # Variablen
    rest_url = "https://thestacks.libaac.de/rest/"

    # Ausführung
    session = authenticate_session_rest(email, password, rest_url) # TO DO: Fehlerabfrage, falls login scheitert
    handle = handle

    print('handle: ' + handle)

    all_items = requests.get(rest_url + 'handle/' + handle + '?expand=items').json()
    print('all_items: ')
    print(all_items)
    if all_items['type'] == 'collection':
        print('item 1: ')
        print(all_items['items'][0])
        html_navigation = make_html(rest_url, all_items['items'])
        textfile = open("test.html", "w")
        textfile.write(html_navigation)
        textfile.close()
        ##update_coll(session, rest_url, handle, html_navigation)
        # TO DO: save html_navigation to file
    else:
        print('{handle} ist keine Sammlung.')

    session.close()

# Skript ausführen

if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(
        prog='toc_zeitschrift_rest.py',
        usage='%(prog)s -e: email -p: password -n: handle (int) -w: working directory',
        description='Skript erstellt Inhaltsverzeichnis'
        )
    parser.add_argument('-e', '--email', action='store', help='Admin E-Mail', required=True)
    parser.add_argument('-p', '--password', action='store', help='Admin Password', required=True)
    parser.add_argument('-n', '--number', action='store', help='Handle (Zahl)')
    parser.add_argument('-w', '--work_dir', action='store', default='/opt/dspace/aac/toc-import/',
                            help='Working Directory')  # meherer Angaben werden als Liste erfasst
    args = parser.parse_args()

    email = args.email
    password = args.password
    handle = args.number
    path = args.work_dir
    os.chdir(path)

    sys.exit(main(handle, email, password))

