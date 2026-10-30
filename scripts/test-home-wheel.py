"""One short, muted Home wheel check with isolated history; no desktop input."""
import argparse,hashlib,json,os,pathlib,re,sqlite3,subprocess

root=pathlib.Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser();p.add_argument('--name',default='home-wheel');args=p.parse_args()
if not re.fullmatch(r'[A-Za-z0-9_-]+',args.name):raise SystemExit('Simple result name required')
out=root/'tests/results'/args.name
out.mkdir(parents=True,exist_ok=False)
db=sqlite3.connect(out/'flow.db')
db.execute('CREATE TABLE history(file_key TEXT PRIMARY KEY,path TEXT NOT NULL,size INTEGER,mtime INTEGER,duration REAL,position REAL,finished INTEGER,last_played INTEGER,audio_track INTEGER,sub_track INTEGER,sub_delay REAL,volume REAL,speed REAL)')
for i in range(10):
    db.execute('INSERT INTO history VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)',(str(i),str(out/f'missing-{i}.mkv'),1,1,600,30,0,1000-i,1,0,0,100,1))
db.commit();db.close()
env=os.environ.copy()
env.update(FLOW_TEST_BACKGROUND='1',FLOW_TEST_MUTE='1',FLOW_SCENARIO='home-wheel',FLOW_QUIT_MS='3500',FLOW_LOG_DIRECTORY=str(out/'logs'),FLOW_SETTINGS_FILE=str(out/'settings.ini'),FLOW_HISTORY_DB=str(out/'flow.db'),FLOW_THUMBS_DIR=str(out/'thumbs'),PATH=str(root/'deps/Qt/bin')+';'+env['PATH'],QT_PLUGIN_PATH=str(root/'deps/Qt/plugins'),QML_IMPORT_PATH=str(root/'deps/Qt/qml'))
env.pop('FLOW_INSTANCE_NAME',None)
exe=root/'build/FlowPlayer.exe'
result=subprocess.run([str(exe)],env=env,timeout=15,capture_output=True)
log=(out/'logs/flowplayer.log').read_text(encoding='utf-8')
match=re.search(r'HOME_WHEEL before=([\d.-]+) down=([\d.-]+) up=([\d.-]+) volumeBefore=([\d.-]+) volumeAfter=([\d.-]+) count=(\d+)',log)
assert result.returncode==0 and 'CLEAN_EXIT' in log and match,log[-3000:]
before,down,up,v0,v1,count=map(float,match.groups())
assert down>before and up<down and v0==v1 and count==10,match.group(0)
assert 'WINDOW_ACTIVE=1' not in log
assert not any(x in log for x in ['ReferenceError','TypeError','qrc:']),log
summary=dict(passed=True,exeSha256=hashlib.sha256(exe.read_bytes()).hexdigest(),contentYBefore=before,contentYDown=down,contentYUp=up,volumeBefore=v0,volumeAfter=v1,rows=count)
(out/'summary.json').write_text(json.dumps(summary,indent=2))
print(json.dumps(summary,indent=2))
