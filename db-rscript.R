args <- commandArgs(trailingOnly = TRUE)
repo_name <- args[1]
print(repo_name)

print("hello world")

mainDir <- "/path/to/dir"
subDir <- repo_name
fullDir <- file.path(mainDir,subDir)
print(fullDir)
print(system("df -h"))

library(RPostgreSQL)

driver <- dbDriver("PostgreSQL")

host <- "<host-id>.<region>.redshift.amazonaws.com"
database <- "db"
port <- <port-number>
uid <- system("echo $USER", intern=TRUE)
pwd <- system("echo $PASS", intern = TRUE)
print(uid)
print(pwd)

setwd(file.path(mainDir, subDir))
write("testing text",paste('testing.txt',sep=''))

redshift_conn <- dbConnect(driver,
                           host = host,
                           port = port,
                           user = uid,
                           password = pwd,
                           dbname = database)

bm <- dbSendQuery(redshift_conn, "SELECT TOP 50 * FROM <schema>.<table>") 
measurements <- dbFetch(bm)

# Check if /path/to/dir/<repo_name> exists, if not, create it, and put output file under this folder.

if (file.exists(subDir)){
  setwd(file.path(mainDir, subDir))
  print("Directory already exsits")
} else {
  dir.create(file.path(mainDir, subDir))
  setwd(file.path(mainDir, subDir))
}

now<-format(Sys.time(), "%d%b%y-%H:%M:%S")

tableswrite <- dbListTables(redshift_conn)
print(head(tableswrite, 50))

# Write to files with dynamic filesnames
write(tableswrite,paste('TABLES','-',now,'.html',sep=''))
write.csv(baseline_measurements,paste('measurements','-',now,'.html',sep=''))

dbDisconnect(redshift_conn)