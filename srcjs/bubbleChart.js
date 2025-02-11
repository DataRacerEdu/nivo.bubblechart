import React, { useState } from "react";
import { ResponsiveCirclePacking } from '@nivo/circle-packing'

const initialData = {
  "name": "nivo",
  "children": [
    {
      "name": "Test A",
      "color": "#ff5f56",
      "labelColor": "#ffffff",
      "loc": 11
    },
    {
      "name": "Test B",
      "color": "#ff5f56",
      "labelColor": "#ffffff",
      "loc": 56
    },
    {
      "name": "Test C",
      "color": "#ff5f56",
      "labelColor": "#ffffff",
      "loc": 40
    }
  ]
}



function BubleChart(props) {

      // const [data, setData] = useState(initialData);
      const [data, setData] = useState(props.dataJSON);
      const [selectedNode, setSelectedNode] = useState(null);
      const [hoveredNode, setHoveredNode] = useState(null);

      console.log('Data:', props);

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

        // Toggle the clicked node's color between transparent, red, and brown
        const targetNode = findNode(newData, node.data.name);
        if (targetNode) {
            // Send data to shiny
            if(targetNode.color === props.activeColor) {
              // console.log('Target node:', "Deselect");
              // Send data to Shiny with the edited data
              // setTimeout(function() {
                Shiny.setInputValue(
                  `${props.element_id}_clicked`,
                  "DESELECT_EVENT",
                  {priority: "event"}
                );
              // }, 1000);
            } else {
              // console.log('Target node:', targetNode.name);
              // setTimeout(function() {
                Shiny.setInputValue(
                  `${props.element_id}_clicked`,
                  targetNode.name,
                  {priority: "event"}
                );
              // }, 1000);
            }
            targetNode.color = targetNode.color === props.activeColor ? props.mainColor : props.activeColor;
            targetNode.labelColor = targetNode.labelColor === props.mainColor ? props.labelColor : props.mainColor;
            // console.log('Target node:', targetNode.name);
            setSelectedNode(targetNode); // Update selected node
        }

        setData(newData); // Update data state
    };


  return (
    <div style={{height: '400px'}}>
      <ResponsiveCirclePacking
        data={data}
        margin={{ top: 20, right: 20, bottom: 20, left: 20 }}
        id="name"
        value="value"
        leavesOnly={true}
        // colors={{ scheme: 'nivo' }}
        // colors={(node) => {
        //   return node.data.color;
        // }}
        colors={(node) => {
          return hoveredNode === node.data.name ? 'transparent' : node.data.color;
        }}
        padding={8}
        enableLabels={true}
        label={hoveredNode !== null ? 'formattedValue' : 'id'}
        labelsSkipRadius={0}
        // labelTextColor={(node) => {
        //   return node.data.labelColor;
        // }}
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

export default BubleChart;
