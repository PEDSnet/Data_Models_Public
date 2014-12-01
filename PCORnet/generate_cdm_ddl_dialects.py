import os
import json
import sqlalchemy as sa

# Read in config file
with open('cdm_config.json', 'r') as f:
    config = json.loads(f.read())

# Get metadata from sqlalchemy_tables.py
os.sys.path.append(os.path.abspath('.'))
from sqlalchemy_cdm_tables import Base
meta = Base.metadata

# Factory to configure an engine 'executor' function that dumps into the passed
# file output object.
def dump_gen(f):
    def dump(sql, *multiparams, **params):
        f.write(str(sql.compile(dialect=engine.dialect)) + ';\n')
    return dump

for dialect in config['dialects']:
    # Get a handle on the output file
    f = open(dialect['outfile'], 'w')
    # Create an executor function that dumps to the output file
    dump = dump_gen(f)
    # Create an engine with the conn_str stub (which defines the dialect)
    # the mock strategy which passes all statements to the executor, and
    # the dump executor function
    engine = sa.create_engine(dialect['conn_str'], strategy='mock',
                              executor=dump)
    # Set MS-SQL server version to 2008 to generate DATE and TIME data
    # types for more specificity (MS-SQL 2005 only has DATETIME).
    if dialect['conn_str'] == 'mssql://':
        MS_2008_VERSION = (10,)
        engine.dialect.server_version_info = MS_2008_VERSION
    # Write all the create statements to the output file
    meta.create_all(engine, checkfirst=False)
    # Close up the file
    f.close()
