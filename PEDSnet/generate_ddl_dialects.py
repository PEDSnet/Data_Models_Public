import json
import sqlalchemy as sa

# Read in config file
with open('.config.json', 'r') as f:
    config = json.loads(f.read())

if config['sconn_str']:
    sengine = sa.create_engine(config['sconn_str'])
    meta = sa.MetaData()
    meta.reflect(bind=sengine)
else:
    import os
    os.sys.path.append(os.path.abspath('.'))
    from sqlalchemy_tables import Base
    meta = Base.metadata

def dump_gen(f):
    def dump(sql, *multiparams, **params):
        f.write(str(sql.compile(dialect=engine.dialect)))
    return dump

for dialect in config['dialects']:
    f = open(dialect['outfile'], 'w')
    dump = dump_gen(f)
    engine = sa.create_engine(dialect['conn_str'], strategy='mock', executor=dump)
    meta.create_all(engine, checkfirst=False)
    f.close()
