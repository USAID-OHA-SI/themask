#' Generate a Unique ID
#'
#' This function is used to create a unique ID (UID) to mimic the UIDs created
#' and used by DATIM for the MER and other PEPFAR Structured Datasets.
#'
#' @param codeSize character length for UID output (default = 11)
#'
#' @return random alphanumeric string
#' @export
#'
#' @examples
#'  generate_uid()

generate_uid <- function(codeSize=11){
  #Generate a random seed
  runif(1)
  allowedLetters<-c(LETTERS,letters)
  allowedChars<-c(LETTERS,letters,0:9)
  #First character must be a letter according to the DHIS2 spec
  firstChar<-sample(allowedLetters,1)
  otherChars<-sample(allowedChars,codeSize-1)
  uid<-paste(c(firstChar,paste(otherChars,sep="",collapse="")),sep="",collapse="")
  return(uid)
}
