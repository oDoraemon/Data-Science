# read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-readRDS("Source_Classification_Code.rds")

# format data
NEI <- transform(NEI, type = as.factor(type), year=as.Date(as.character(year),"%Y"))            
SCC <- transform(SCC, SCC = as.character(SCC))


# subset baltimore data
bal <- subset(NEI, fips == "24510")

sector <- as.character(SCC$EI.Sector)
scc <- SCC$SCC

# extract the coal combustion-related item
# I take the key word "Mobile" as motor vehicle, I am not quite sure they are the same thing
motor <- sapply(sector,function(v) return ("Mobile" %in% unlist(strsplit(v," "))))
sccSub <- subset(scc,motor)

# subset the bal dataset with the SCC id obtained from SCC sub-dataset
motorSub <- subset(bal, bal$SCC %in% sccSub)

# calculate the total Emission
motorEmission <- with(motorSub, tapply(Emissions, year, sum))

# plot
png(filename = "plot5.png", width = 860, height = 480, units = "px")

plot(seq(1999,2008,3),motorEmission, main = "Baltimore motor vehicle Emission",pch = 19, col = "steelblue", xlab = "year", ylab = "Emission (*ton)", xlim = c(1998, 2009),ylim = c(350,900))
text(seq(1999,2008,3) + 0.5,motorEmission + 10, round(motorEmission,0))
lines(seq(1999,2008,3),motorEmission)

dev.off()