library(ggplot2)
library(grid)
# read in data
NEI <-readRDS("summarySCC_PM25.rds")

# format data
NEI <- transform(NEI,type=as.factor(type), year=as.Date(as.character(year),"%Y"))            

# subset baltimore data
bal <- subset(NEI, fips == "24510")

# plot
png(filename = "plot3.png", width = 860, height = 480, units = "px")

# as there is an outlier(~1400) in NONPOINT-2000, I plan to plot two figures with and without the outlier
# ggplot2 doesn't support the par(mfrow = c(2,1) setting), so I found this code from internet, to make a muliplot in one image. 
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)

g <- ggplot(bal, aes(year, Emissions))
p <- g + geom_point(alpha=1/3, color = "blue", size = 3) + facet_grid(.~type) + geom_smooth(method="lm", color = "steelblue") + theme_bw(base_size = 10) + labs(x = "year") + labs(y = "Emissions") + labs(title = "Pollutant Emissions in Baltimore (with nonpoint outlier)")

# as tere is just one outlier, it should take little effect on the whole linear regression. So instead of deleting or replacing the outlier, I just set the ylim, to make the figure look more clear.
p2 <- g + geom_point(alpha=1/3, color = "blue", size = 3) + facet_grid(.~type) + geom_smooth(method="lm", color = "steelblue") + theme_bw(base_size = 10) + labs(x = "year") + labs(y = "Emissions") + labs(title = "Pollutant Emissions in Baltimore(without nonpoint outlier)") +  coord_cartesian(ylim = c(-50, 400))
print(p, vp = vplayout(1, 1))
print(p2, vp = vplayout(2, 1))

dev.off()