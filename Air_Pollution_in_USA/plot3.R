library(ggplot2)
# read in data
NEI <-readRDS("summarySCC_PM25.rds")

# format data
NEI <- transform(NEI,type=as.factor(type), year=as.Date(as.character(year),"%Y"))            

# subset baltimore data
bal <- subset(NEI, fips == "24510")

# plot
png(filename = "plot3.png", width = 860, height = 480, units = "px")

g <- ggplot(bal, aes(year, Emissions))
p <- g + geom_point(alpha=1/3, color = "blue", size = 3) + facet_grid(.~type) + geom_smooth(method="lm", color = "steelblue") + theme_bw(base_size = 10) + labs(x = "year") + labs(y = "Emission") + labs(title = "Pollutant Emission in Baltimore")
print(p)

dev.off()