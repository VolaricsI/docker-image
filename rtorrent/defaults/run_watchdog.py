#!/usr/bin/env python

import sys
import os
import signal
import re

from supervisor.childutils import listener

def write_stdout(s):
    sys.stdout.write(s)
    sys.stdout.flush()


def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()


def main():

     while True:
        headers, body = listener.wait(sys.stdin, sys.stdout)
        body = dict([pair.split(":") for pair in body.split(" ")])
#        write_stderr("Headers: %r\n" % repr(headers))
#        write_stderr("Body: %r\n" % repr(body))
        listener.ok(sys.stdout)

        write_stderr("==========>\t%s\t===>\t%s\t ++++++\n" % (body["processname"] , headers["eventname"]) );

        if body["processname"] != "rtorrent":
	    continue

        write_stderr("==========> most probalom kigyilkolni...\n");

	pidfile = open('/config/supervisord.pid','r')
	pid 	= int( pidfile.readline() );
        os.kill( pid,signal.SIGQUIT )


if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])

    main()
## Allapotok elnevezesei:
###events=PROCESS_STATE,PROCESS_STATE_STARTING,PROCESS_STATE_RUNNING,PROCESS_STATE_BACKOFF,PROCESS_STATE_STOPPING,PROCESS_STATE_EXITED,PROCESS_STATE_STOPPED,PROCESS_STATE_FATAL,PROCESS_STATE_UNKNOWN
