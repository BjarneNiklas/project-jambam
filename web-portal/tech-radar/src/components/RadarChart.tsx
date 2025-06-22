import React, { useEffect, useRef } from 'react';
import { useTranslation } from 'react-i18next';
import * as d3 from 'd3';
import { TechRadarData, TechItem } from '../data/techRadarData';
import { Box, Paper, Typography, Fade, Grow, useMediaQuery, useTheme } from '@mui/material';

interface RadarChartProps {
  data: TechRadarData;
  width?: number;
  height?: number;
}

interface Point {
  x: number;
  y: number;
  item: TechItem;
}

export const RadarChart: React.FC<RadarChartProps> = ({ 
  data, 
  width = 800, 
  height = 600 
}) => {
  const { t } = useTranslation();
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));
  const svgRef = useRef<SVGSVGElement>(null);
  const gRef = useRef<SVGGElement>(null);

  const responsiveWidth = isMobile ? Math.min(width, window.innerWidth - 20) : width;
  const responsiveHeight = isMobile ? Math.min(height, window.innerHeight * 0.7) : height;

  useEffect(() => {
    if (!svgRef.current || !gRef.current || !data) return;

    const svg = d3.select(svgRef.current);
    const g = d3.select(gRef.current);

    g.selectAll("*").remove(); // Clear previous chart content

    const margin = { top: 70, right: 70, bottom: 70, left: 70 };
    const chartWidth = responsiveWidth - margin.left - margin.right;
    const chartHeight = responsiveHeight - margin.top - margin.bottom;

    const chartCenterTransform = `translate(${margin.left + chartWidth / 2}, ${margin.top + chartHeight / 2})`;
    g.attr("transform", chartCenterTransform);

    const rings = data.rings.map((ring, i) => ({
      ...ring,
      radius: (i + 1) * (Math.min(chartWidth, chartHeight) / 2) / 4
    }));

    const quadrants = data.quadrants.map((quadrant, i) => ({
      ...quadrant,
      angle: (i * Math.PI) / 2
    }));

    const ringColors = d3.scaleOrdinal<string>()
      .domain(rings.map(r => r.name))
      .range(['#10b981', '#f59e0b', '#3b82f6', '#ef4444']);

    rings.forEach((ring, i) => {
      g.append("circle")
        .attr("r", ring.radius)
        .attr("fill", "none")
        .attr("stroke", "rgba(255, 255, 255, 0.2)")
        .attr("stroke-width", 1.5)
        .attr("stroke-dasharray", "6,4");
      
      const labelRadius = ring.radius + (isMobile ? 8 : 12);
      g.append("text")
        .attr("x", labelRadius)
        .attr("y", 0)
        .attr("text-anchor", "start")
        .attr("dy", "-0.3em")
        .attr("font-size", isMobile ? "11px" : "14px")
        .attr("font-weight", "700")
        .attr("fill", ringColors(ring.name))
        .text(ring.name.toUpperCase());
    });

    quadrants.forEach(quadrant => {
      const angle = quadrant.angle;
      const maxRadius = Math.max(...rings.map(r => r.radius));
      g.append("line")
        .attr("x2", Math.cos(angle) * maxRadius)
        .attr("y2", Math.sin(angle) * maxRadius)
        .attr("stroke", "rgba(255, 255, 255, 0.2)")
        .attr("stroke-width", 1.5);
      
      const labelRadius = maxRadius + (isMobile ? 25 : 35);
      g.append("text")
        .attr("x", Math.cos(angle + Math.PI / 4) * labelRadius)
        .attr("y", Math.sin(angle + Math.PI / 4) * labelRadius)
        .attr("text-anchor", "middle")
        .attr("font-size", isMobile ? "15px" : "18px")
        .attr("font-weight", "800")
        .attr("fill", "rgba(255, 255, 255, 0.9)")
        .text(quadrant.name);
    });

    const points: Point[] = [];
    data.quadrants.forEach(quadrant => {
      data.rings.forEach(ring => {
        const itemsInSegment = data.items.filter(
          item => item.quadrant === quadrant.name && item.ring === ring.name
        );
        
        if (itemsInSegment.length === 0) return;

        const quadrantDef = quadrants.find(q => q.name === quadrant.name)!;
        const ringDef = rings.find(r => r.name === ring.name)!;
        
        const ringWidth = ringDef.radius / 4;
        const angleSegment = Math.PI / 2;

        itemsInSegment.forEach((item, i) => {
          const angleJitter = (Math.random() * 0.8 + 0.1) * angleSegment;
          const itemAngle = quadrantDef.angle + angleJitter;
          
          const radiusJitter = (Math.random() * 0.8 + 0.1) * ringWidth;
          const itemRadius = ringDef.radius - radiusJitter;

          points.push({
            x: Math.cos(itemAngle) * itemRadius,
            y: Math.sin(itemAngle) * itemRadius,
            item: item
          });
        });
      });
    });

    const itemGroups = g.selectAll(".item")
      .data(points)
      .enter()
      .append("g")
      .attr("class", "item")
      .attr("transform", (d: Point) => `translate(${d.x}, ${d.y})`);

    const circleRadius = isMobile ? 7 : 9;
    itemGroups.append("circle")
      .attr("r", circleRadius)
      .attr("fill", (d: Point) => ringColors(d.item.ring))
      .attr("stroke", "rgba(10, 10, 10, 0.7)")
      .attr("stroke-width", 3)
      .style("cursor", "pointer");

    const labelOffset = circleRadius + (isMobile ? 5 : 6);
    const fontSize = isMobile ? "12px" : "14px";
    itemGroups.append("text")
      .attr("x", labelOffset)
      .attr("y", labelOffset / 2)
      .attr("font-size", fontSize)
      .attr("font-weight", "600")
      .attr("fill", "#ffffff")
      .attr("paint-order", "stroke")
      .attr("stroke", "rgba(10, 10, 10, 0.9)")
      .attr("stroke-width", "4px")
      .attr("stroke-linecap", "butt")
      .attr("stroke-linejoin", "miter")
      .style("pointer-events", "none")
      .text((d: Point) => d.item.name);

    const tooltip = d3.select("body").append("div")
      .attr("class", "tooltip")
      .style("opacity", 0)
      .style("position", "absolute")
      .style("pointer-events", "none")
      .style("background", "rgba(20, 20, 20, 0.9)")
      .style("color", "white")
      .style("padding", "12px")
      .style("border-radius", "12px")
      .style("font-family", "Inter, sans-serif")
      .style("z-index", "1000")
      .style("backdrop-filter", "blur(10px)")
      .style("border", "1px solid rgba(255, 255, 255, 0.1)")
      .style("box-shadow", "0 10px 30px rgba(0, 0, 0, 0.3)")
      .style("max-width", isMobile ? "250px" : "300px")
      .style("line-height", "1.6")
      .style("transition", "opacity 0.2s");

    // Force simulation for collision avoidance
    const simulation = d3.forceSimulation(points as d3.SimulationNodeDatum[])
      .force("collide", d3.forceCollide().radius(isMobile ? 12 : 15).strength(0.8))
      .force("x", d3.forceX((d: any) => d.x).strength(0.1))
      .force("y", d3.forceY((d: any) => d.y).strength(0.1))
      .stop();

    // Run simulation for a number of ticks
    for (let i = 0; i < 120; ++i) {
      simulation.tick();
    }

    itemGroups
      .attr("transform", (d: any) => `translate(${d.x}, ${d.y})`);

    itemGroups
      .on("mouseover", function(event: MouseEvent, d: any) {
        const thisGroup = d3.select(this);
        itemGroups.transition().duration(200).style("opacity", (other_d) => other_d === d ? 1 : 0.3);
        thisGroup.select("circle").transition().duration(200).attr("r", circleRadius * 1.5);
        thisGroup.select("text").transition().duration(200).attr("font-size", (parseFloat(fontSize) * 1.2) + "px");
        
        tooltip.transition().duration(200).style("opacity", 1);
        tooltip.html(`
          <div style="font-size: 1.2em; font-weight: 700; color: ${ringColors(d.item.ring)}; margin-bottom: 8px;">${d.item.name}</div>
          <div><strong style="color: #a5b4fc;">${t('filters.quadrant')}:</strong> ${d.item.quadrant}</div>
          <div><strong style="color: #f9a8d4;">${t('filters.ring')}:</strong> ${d.item.ring}</div>
          <div style="margin-top: 8px; padding-top: 8px; border-top: 1px solid rgba(255, 255, 255, 0.2); opacity: 0.9;">${d.item.description}</div>
        `);
        const tooltipNode = tooltip.node();
        if (!tooltipNode) return;
        const tooltipX = Math.min(event.pageX + 15, window.innerWidth - 300);
        const tooltipY = Math.max(event.pageY - 15, 20);
        tooltip.style("left", `${tooltipX}px`).style("top", `${tooltipY}px`);
      })
      .on("mouseout", function() {
        const thisGroup = d3.select(this);
        itemGroups.transition().duration(200).style("opacity", 1);
        thisGroup.select("circle").transition().duration(200).attr("r", circleRadius);
        thisGroup.select("text").transition().duration(200).attr("font-size", fontSize);
        tooltip.transition().duration(200).style("opacity", 0);
      });

    const zoom = d3.zoom<SVGSVGElement, unknown>()
      .scaleExtent([0.5, 5])
      .on("zoom", (event) => {
        g.attr("transform", event.transform);
      });

    svg.call(zoom as any)
       .call(zoom.transform as any, d3.zoomIdentity.translate(margin.left + chartWidth / 2, margin.top + chartHeight / 2).scale(1));
    
  }, [data, responsiveWidth, responsiveHeight, isMobile, t]);

  return (
    <Fade in timeout={1000}>
      <Paper 
        elevation={0}
        sx={{ 
          p: isMobile ? 1 : 2, 
          m: isMobile ? 1 : 2,
          background: 'rgba(255, 255, 255, 0.05)',
          backdropFilter: 'blur(20px)',
          border: '1px solid rgba(255, 255, 255, 0.1)',
          borderRadius: 4,
          overflow: 'hidden',
        }}
      >
        <Grow in timeout={1200}>
          <Box sx={{ textAlign: 'center', p: 2 }}>
            <Typography variant={isMobile ? "h6" : "h5"} sx={{ fontWeight: 700 }}>
              {t('radar.title')}
            </Typography>
            <Typography variant="body2" sx={{ opacity: 0.8, mt: 1 }}>
              {t('radar.subtitle')}
              <br/>
              <span style={{ fontSize: '0.9em', color: theme.palette.primary.main }}>Scroll to zoom, drag to pan</span>
            </Typography>
          </Box>
        </Grow>
        
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center' }}>
          <svg
            ref={svgRef}
            width={responsiveWidth}
            height={responsiveHeight}
            style={{ 
              maxWidth: '100%', 
              height: 'auto',
              cursor: 'grab'
            }}
          >
            <g ref={gRef}></g>
          </svg>
        </Box>
      </Paper>
    </Fade>
  );
}; 