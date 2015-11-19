# read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <-readRDS("Source_Classification_Code.rds")

# format data
NEI <- transform(NEI, type = as.factor(type), year=as.Date(as.character(year),"%Y"))            
SCC <- transform(SCC, SCC = as.character(SCC))


# subset baltimore data
bal <- subset(NEI, fips == "24510")
LA <- subset(NEI, fips == "06037")

sector <- as.character(SCC$EI.Sector)
scc <- SCC$SCC

# extract the coal combustion-related item
# I take the key word "Mobile" as motor vehicle, I am not quite sure they are the same thing
motor <- sapply(sector,function(v) return ("Mobile" %in% unlist(strsplit(v," "))))
sccSub <- subset(scc,motor)

# subset the bal dataset with the SCC id obtained from SCC sub-dataset
motorSub0 <- subset(bal, bal$SCC %in% sccSub)
motorSub1 <- subset(LA, LA$SCC %in% sccSub)

# calculate the total Emission
motorEmission0 <- with(motorSub0, tapply(Emissions, year, sum))
motorEmission1 <- with(motorSub1, tapply(Emissions, year, sum))


# plot
png(filename = "plot6.png", width = 860, height = 480, units = "px")
par(mfrow = c(1,2), mar = c(5,4,2,1))

plot(seq(1999,2008,3),motorEmission0, main = "Motor vehicle Emission in Baltimore & LA",pch = 19, col = "steelblue", xlab = "year", ylab = "Emission (*ton)", xlim = c(1998, 2009),ylim = c(0,11000))
points(seq(1999,2008,3),motorEmission1, pch = 19,col = "red")

lines(seq(1999,2008,3),motorEmission0,lwd = 2, col = "steelblue")
lines(seq(1999,2008,3),motorEmission1,lwd = 2, col = "red")

text(seq(1999,2008,3) + 0.5,motorEmission0 + 100, round(motorEmission0,0))
text(seq(1999,2008,3) + 0.5,motorEmission1 - 100, round(motorEmission1,0))

legend("right", lty=1, lwd = 2, col = c("red", "blue"), legend = c("LA", "Baltimore"))

# the rate change compare
getrate <- function(x) {
  rate = list()
  for (i in 2:length(x))
    rate = c(rate,(x[i] - x[i - 1])/x[i - 1])
  rate
}

# the rate plot
rate0 = unlist(getrate(motorEmission0))
rate1 = unlist(getrate(motorEmission1))

plot(seq(2002,2008,3),rate0, main = "Emissions change rate to the last 3 year",pch = 19, col = "steelblue", xlab = "year", ylab = "rate to last 3year", xlim = c(2000, 2009), ylim = c(-1, 1))
lines(seq(2002,2008,3),rate0,lwd = 2, col = "steelblue")


points(seq(2002,2008,3),rate1, pch = 19, col = "red")
lines(seq(2002,2008,3),rate1,lwd = 2, col = "red")

text(seq(2002,2008,3) - 0.5,rate0, round(rate0,2), col = "steelblue")
text(seq(2002,2008,3) + 0.5,rate1, round(rate1,2), col = "red")
abline(h=0,lty = 2)

dev.off()