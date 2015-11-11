# read in data
NEI <-readRDS("summarySCC_PM25.rds")

# format data
NEI <- transform(NEI,type=as.factor(type), year=as.factor(year))

# subset baltimore data
bal <- subset(NEI, fips == "24510")
# caculate the total emission by year
balEmission <- tapply(bal$Emission, bal$year, sum)

# plot
png(filename = "plot2.png", width = 480, height = 480, units = "px")

plot(seq(1999,2008,3),balEmission, pch=20, main = "Total Emissions of Baltimore", xlab="year", ylab="Total Emission (*ton)",ylim = c(1800,3500))
text(seq(1999,2008,3), balEmission + 100, round(balEmission,0))
lines(seq(1999,2008,3),balEmission)

dev.off()