import os
import json
from shutil import move
from tempfile import NamedTemporaryFile
import re
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
        f.write(str(sql.compile(dialect=engine.dialect)))
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

    # Hack to fix up Oracle data types by search and replace. This avoids
    # subclassing the actual interpreter, which would be more work.
    # Replace the to-be-depreciated INTEGER data type with NUMBER(10) and
    # replace TIME data types, which are incorrectly generated, with
    # TIMESTAMP.
    if dialect['conn_str'] == 'oracle://':
        # Make a temp file
        with NamedTemporaryFile(delete=False) as tmpf:
            # Read from the output file
            with open(dialect['outfile'], 'r') as srcf:
                for line in srcf:
                    # Replace INTEGER with NUMBER(10)
                    line = re.sub('INTEGER', 'NUMBER(10)', line)
                    # Replace TIME with TIMESTAMP
                    line = re.sub('TIME', 'TIMESTAMP', line)
                    # Write the line
                    tmpf.write(line)
        # Replace the original output file with the new one
        move(tmpf.name, srcf.name)
