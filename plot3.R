library(data.table)

# loading dataset settings
load_data <- function(){      
      zipfile_name <- "household_power_consumption.zip"
      # download zipfile
      if (!file.exists(zipfile_name)) {
            file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
            download.file(file_url, zipfile_name, method = "curl")
      }
      
      # unzip dataset
      file_name <- "household_power_consumption.txt"
      if (!file.exists(file_name)) {
            unzip(zipfile_name)
      }
      
      # read the dataset from the dates 2007-02-01 and 2007-02-02
      # use grep to find the lines contains "1/2/2007" 
      skip_lines <- (grep("1/2/2007", readLines("household_power_consumption.txt"))[1] - 1)
      # use the same method to get the number of rows we need to read in the original dataset
      n_rows <- (grep("3/2/2007", readLines("household_power_consumption.txt"))[1] - 
                       grep("1/2/2007", readLines("household_power_consumption.txt"))[1])
      # however, if we skip rows, the column names cannot be read automatically
      # so, we can read a small part of the original dataset to get the column names
      hpc <- fread(file_name, nrows = 3)
      col_names <- colnames(hpc)
      # read the dataset 
      hpc_df <<- fread(file_name, skip = skip_lines, nrows = n_rows, col.names = col_names)
      
}

# reset graphical parameters before plotting
reset_par <- function(){
      par(mfrow = c(1, 1), mar = c(5.1, 4.1, 4.1, 2.1))
}

# plot settings
plot_3 <- function(){
      # prepare data
      date_time <- strptime(paste(hpc_df$Date, hpc_df$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
      # set file device
      png("plot3.png", width = 480, height = 480)
      # plot
      plot(date_time, hpc_df$Sub_metering_1, type = "l", 
           ylab = "Energy Submetering", xlab = "")
      lines(date_time, hpc_df$Sub_metering_2, type = "l", col = "red")
      lines(date_time, hpc_df$Sub_metering_3, type = "l", col = "blue")
      legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
             lty=1, lwd=2.5, col=c("black", "red", "blue"))
      # close file device
      dev.off()
}

# workflow
load_data()
reset_par()
plot_3()



