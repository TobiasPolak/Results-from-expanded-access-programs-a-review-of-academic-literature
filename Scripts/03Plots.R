### Time plots of INVESTIGATIONS

# Select data for investigations where device is FALSE
plot.df <- df.inv[which(df.inv$device == FALSE),]

# Calculate count and percentage change by year
order.time.year.inv <- plot.df %>% 
  group_by(year) %>% 
  summarise(count = n()) %>% 
  mutate(pct_change = (lead(count) / count - 1) * 100)

# Uncomment the following line to remove data for the year 2022
# order.time.year.inv <- order.time.year.inv[-which(order.time.year.inv$year == 2022), ]

# Line plot for expanded access publications over time
yearly.plot.inv.line <- ggplot2::ggplot(data = order.time.year.inv, aes(x = year, y = count)) +
  geom_point() +
  theme_bw() +
  geom_smooth(method = 'loess', se = FALSE) +
  ggtitle("Expanded Access Publications over time") +
  xlab("Time (years)") +
  ylab("Number of publications") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_fill_nejm()

# Bar plot for expanded access publications over time
yearly.plot.inv.bar <- ggplot2::ggplot(data = order.time.year.inv, aes(x = year, y = count)) +
  geom_col(colour = 'black') +
  theme_bw() +
  ggtitle("Expanded Access Publications over time") +
  xlab("Time (years)") +
  ylab("Number of publications") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_fill_jama()


### Time plots of all INCLUSIONS

# Select all data for inclusions
plot.df <- df.incl[]
plot.df$type <- 'legal/ethical/political'
plot.df$type[plot.df$investigation] <- 'therapeutic'
plot.df$type[plot.df$device] <- 'device/procedure'

# Calculate count by year and type
order.time.year.incl <- plot.df %>% 
  group_by(year, type) %>% 
  summarise(count = n())

# Uncomment the following line to remove data for the year 2022
# order.time.year.incl <- order.time.year.incl[-which(order.time.year.incl$year == 2022), ]

# Bar plot for all inclusions over time
barchart.all <- ggplot(order.time.year.incl, aes(x = year, y = count, group = type, fill = type)) +
  geom_col(color = "black", position = "fill", size = .5) +
  geom_bar(stat = "identity", colour = 'black') +
  theme_bw() +
  ggtitle("Expanded Access Publications over time") +
  xlab("Time (years)") +
  ylab("Number of publications") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_fill_nejm()

### ADDING COVID

# Update type for COVID-related inclusions
plot.df$type[plot.df$covid] <- 'COVID'

# Calculate count by year and type (including COVID)
order.time.year.incl.covid <- plot.df %>% 
  group_by(year, type) %>% 
  summarise(count = n())

# Uncomment the following line to remove data for the year 2022
# order.time.year.incl.covid <- order.time.year.incl.covid[-which(order.time.year.incl.covid$year == 2022), ]

# Bar plot for all inclusions over time (including COVID)
barchart.all.covid <- ggplot(order.time.year.incl.covid, aes(x = year, y = count, group = type, fill = type)) +
  geom_col(color = "black", position = "fill", size = .5) +
  geom_bar(stat = "identity", colour = 'black') +
  theme_bw() +
  ggtitle("Expanded Access Publications over time") +
  xlab("Time (years)") +
  ylab("Number of publications") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_fill_nejm()
ggsave('barchart.all.covid.png', plot = barchart.all.covid, width = 20, height = 10, units = 'cm', dpi = 600) 

# Spearman correlation test between year and count for investigations
spearmantest.inv <- cor.test(order.time.year.inv$year, order.time.year.inv$count, method = "spearman")


### Time plots of INVESTIGATIONS (COVID-related)

# Select data for investigations and COVID-related entries
plot.df <- df.inv[]
plot.df$type <- 'investigation'
plot.df$type[plot.df$covid] <- 'COVID'
plot.df <- plot.df[-which(plot.df$device == TRUE),]

# Calculate count by year and type (including COVID)
order.time.year.inv.covid <- plot.df %>% 
  group_by(year, type) %>% 
  summarise(count = n())

# Uncomment the following line to remove data for the year 2022
# order.time.year.incl.covid <- order.time.year.incl.covid[-which(order.time.year.incl.covid$year == 2022), ]

# Update type for non-COVID investigations
order.time.year.inv.covid$type[order.time.year.inv.covid$type == 'investigation'] <- 'Non-COVID'

# Bar plot for expanded access publications of therapeutic investigations over time (including COVID)
barchart.all.covid.inv <- ggplot(order.time.year.inv.covid, aes(x = year, y = count, group = type, fill = type)) +
  geom_bar(stat = "identity", col = 'black') +
  ggtitle("Expanded Access publications of therapeutic investigations over time") +
  xlab("Time (years)") +
  ylab("Number of publications") +
  scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
  scale_fill_manual(values = c("grey28", 'grey')) +
  theme(legend.title = element_blank()) +
  coord_cartesian(xlim = c(2000, 2021), ylim = c(0, 175)) +
  theme_bw()

ggsave('barchart.all.covid.inv.png', plot = barchart.all.covid.inv, width = 20, height = 10, units = 'cm', dpi = 600)


## Diagram

# Define variables for the diagram
duplicates <- 10
step1 <- glue('Records identified from PubMed = ', length(df.all$key) + duplicates)
step2 <- glue('Duplicate records removed = ', duplicates)
step3 <- glue('Records sought for retrieval = ', length(df.all$key))
step4 <- glue('Full-text lacking = ', length(nofulltext))
step5 <- glue(
  'Records screened for eligibility = ',
  length(df.excl1$key),
  '\nBased on\n&#8226; Abstract N = ',
  abstract,
  '\n&#8226; Full-text screening N = ',
  length(read)
)
step6 <- glue(
  'Excluded records = ',
  length(foreignlanguage) + length(nocompassionateuse) + length(erratareplies) + length(news) +  sum(df.excl5$incl == FALSE),
  '\n&#8226; Non-English language N = ',
  length(foreignlanguage),
  '\n&#8226; No Compassionate Use N = ',
  length(nocompassionateuse),
  '\n&#8226; Errata, Editorials, Replies N = ',
  length(erratareplies),
  '\n&#8226; News articles N = ',
  length(news),
  '\n&#8226; Background article (meta-analysis, guideline, systematic review) = ',
  sum(df.excl5$incl == FALSE)
)
step7 <- glue(
  'All investigations N = ',
  length(incl),
  '\n&#8226; Therapeutic N = ',
  length(inv) - sum(df.inv$device),
  '\n&#8226; Device/procedure N = ',
  sum(df.inv$device),
  '\n&#8226; Other, e.g. ethics/legal/policy N = ',
  length(incl) - length(inv)
)
step8 <- glue(
  'Other type of investigations N = ',
  sum(df.inv$device) + length(incl) - length(inv),
  '\n&#8226; Device/procedure N = ',
  sum(df.inv$device),
  '\n&#8226; Other, e.g. ethics/legal/policy N = ',
  length(incl) - length(inv)
)
step9 <- glue(
  'Investigations of therapeutics N = ',
  length(inv) - sum(df.inv$device)
)

## This code automatically creates a flowchart.
# Create the flowchart using the grViz function
r <- grViz(
  "
digraph cohort_flow_chart
{
node [fontname = Helvetica, fontsize = 12, shape = box, width = 4]

b[label = '@@2']
c[label = '@@1']
d[label = '@@3']
e[label = '@@4']
f[label = '@@5']
g[label = '@@7']
h[label = '@@6']
i[label = '@@8']
j[label = '@@9']

{ rank = same; b, c}
{ rank = same; d, e}
{ rank = same; f, h}
{ rank = same; g, i}

c -> b [ minlen = 4 ];
c -> d;
d -> e [ minlen = 4 ];
d -> f;
f -> h [ minlen = 4 ];
f -> g;
g -> i [ minlen = 4 ];
g -> j; 
}

[1]: step1
[2]: step2
[3]: step3
[4]: step4
[5]: step5
[6]: step6
[7]: step7
[8]: step8
[9]: step9
 "
) 

# Save the flowchart as an SVG file
r %>% export_svg %>% charToRaw %>% rsvg_svg("flowchart.svg")

