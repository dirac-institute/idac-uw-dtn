#source this file to set up gsi auth
export XrdSecGSICADIR=/etc/xrootd/ca/
export XrdSecGSIUSERCERT=/etc/xrootd/certs/client.crt
export XrdSecGSIUSERKEY=/etc/xrootd/certs/client.key
export XrdSecGSICACHECK=1
export XrdSecDEBUG=1


env | grep Xrd