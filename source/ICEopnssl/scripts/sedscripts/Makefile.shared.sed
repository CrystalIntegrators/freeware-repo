# --------------------------------------------------------------------------
# $Id: $
# --------------------------------------------------------------------------
s#^LDFLAGS=#LDFLAGS=-bsvr4 -brtl -R/webapp/local/lib64 -blibpath:/usr/lib/threads:/usr/lib:/lib #
s#^SHARED_LDFLAGS=#SHARED_LDFLAGS=-Xlinker -bsvr4 -Xlinker -brtl -Xlinker -R/webapp/local/lib64 -Xlinker -blibpath:/usr/lib/threads:/usr/lib:/lib #
