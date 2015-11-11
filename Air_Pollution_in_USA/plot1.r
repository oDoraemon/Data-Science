# read in data
NEI <-readRDS("summarySCC_PM25.rds")

# format data
NEI <- transform(NEI,type=as.factor(type), year=as.factor(year))

# caculate the total emission by year
totalEmission <- tapply(NEI$Emission, NEI$year, sum)

# plot
png(filename = "plot1.png", width = 480, height = 480, units = "px")

plot(seq(1999,2008,3),log10(totalEmission), pch=20, xlab="year", ylab="log 10 total Emission (*ton)", ylim = c(6,7), main = "Total Emissions of USA")
text(seq(1999,2008,3),log10(totalEmission) + 0.05,round(log10(totalEmission),2))
lines(seq(1999,2008,3),log10(totalEmission))

dev.off()