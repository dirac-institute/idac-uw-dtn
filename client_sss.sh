#source this file to set up sss auth
export XrdSecSSSKT=/etc/xrootd/auth/sss_client.keytab
export XrdSecDEBUG=1

env | grep Xrd