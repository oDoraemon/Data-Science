# read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-readRDS("Source_Classification_Code.rds")

# format data
NEI <- transform(NEI, type = as.factor(type), year=as.Date(as.character(year),"%Y"))            
SCC <- transform(SCC, SCC = as.character(SCC))

sector <- as.character(SCC$EI.Sector)
scc <- SCC$SCC

# extract the coal combustion-related item
coal <- sapply(sector,function(v) return ("Coal" %in% unlist(strsplit(v," "))))
sccSub <- subset(scc,coal)

# subset the NEI dataset with the SCC id obtained from SCC sub-dataset
coalSub <- subset(NEI, NEI$SCC %in% sccSub)

# calculate the total Emission
coalEmission <- with(coalSub, tapply(Emissions, year, sum))

# plot
png(filename = "plot4.png", width = 860, height = 480, units = "px")

plot(seq(1999,2008,3),coalEmission, main = "USA Coal combustion-related Emission",pch = 19, col = "steelblue", xlab = "year", ylab = "Emission (*ton)", xlim = c(1998, 2009), ylim = c(320000, 600000))
text(seq(1999,2008,3) + 0.5,coalEmission + 10000, format(coalEmission,scientific = TRUE,digits = 3))
lines(seq(1999,2008,3),coalEmission)

dev.off()