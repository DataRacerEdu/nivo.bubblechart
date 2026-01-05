import React, { useState } from "react";
import { ResponsiveCirclePacking } from '@nivo/circle-packing'

function BubbleChart(props) {
      const [data, setData] = useState(props.dataJSON);
      const [selectedNode, setSelectedNode] = useState(null);
      const [hoveredNode, setHoveredNode] = useState(null);

      // Function to find node by name
      const findNode = (node, name) => {
        if (node.name === name) return node;
        if (node.children) {
            for (const child of node.children) {
                const result = findNode(child, name);
                if (result) return result;
            }
        }
        return null;
    };

    // Function to handle click events
    const handleClick = (node) => {
        const newData = { ...data };

        // If there's a selected node, reset its color to orange
        if (selectedNode && selectedNode.name !== node.data.name) {
            const prevNode = findNode(newData, selectedNode.name);
            if (prevNode) {
                prevNode.color = props.mainColor;
                prevNode.labelColor = props.labelColor;
            }
        }

        // Toggle the clicked node's color
        const targetNode = findNode(newData, node.data.name);
        if (targetNode) {
            const isCurrentlyActive = targetNode.color === props.activeColor;

            // Send data to Shiny if available
            if (typeof window.Shiny !== 'undefined') {
                Shiny.setInputValue(
                  `${props.element_id}_clicked`,
                  isCurrentlyActive ? "DESELECT_EVENT" : targetNode.name,
                  {priority: "event"}
                );
            }

            // Toggle colors
            targetNode.color = isCurrentlyActive ? props.mainColor : props.activeColor;
            targetNode.labelColor = isCurrentlyActive ? props.labelColor : props.mainColor;
            setSelectedNode(targetNode);
        }

        setData(newData); // Update data state
    };


  return (
    <div style={{height: '100%', width: '100%'}}>
      <ResponsiveCirclePacking
        data={data}
        margin={{ top: 20, right: 20, bottom: 20, left: 20 }}
        id="name"
        value="value"
        leavesOnly={true}
        colors={(node) => {
          return hoveredNode === node.data.name ? 'transparent' : node.data.color;
        }}
        padding={8}
        enableLabels={true}
        label={hoveredNode !== null ? 'formattedValue' : 'id'}
        labelsSkipRadius={0}
        labelTextColor={(node) => {
          return hoveredNode === node.data.name ? props.on_hover_title_color : node.data.labelColor;
        }}
        borderWidth={props.borderWidth}
        borderColor={props.mainColor}
        theme={{
          labels: {
              text: {
                  fontSize: 12, // Adjust the font size as needed
              },
          },
        }}
        onClick={handleClick}
        isInteractive={props.isInteractive}
                onMouseEnter={(node) => {
          setHoveredNode(node.data.name);
        }}
        onMouseLeave={() => {
          setHoveredNode(null);
        }}
        tooltip={({
          id,
          value,
          color
        }) => <strong style={{
          color
        }}>
        </strong>}
    />
    </div>
  );
}

export default BubbleChart;
