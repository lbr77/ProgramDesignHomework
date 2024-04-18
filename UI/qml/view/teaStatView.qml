import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import FluentUI

FluContentPage{
    id: root
    title: "统计信息"
    property var datas : []
    FluChart {
        id: chart
        width: parent.width
        height: parent.height
        anchors.fill: parent
        chartType: "bar"
        chartData: {
            let labelD = backend.getCourseList4Tea();
            let label = []
            let data = []
            let bgCol = []
            let bcCol = []
            for(let r of labelD){
                label.push(r.title)
                data.push(r.percentage);
                let rr = ((Math.random() * 255).toFixed(0))
                let g = ((Math.random() * 255).toFixed(0))
                let b = ((Math.random() * 255).toFixed(0))
                bgCol.push(`rgba(${rr},${g},${b},0.2)`)
                bcCol.push(`rgba(${rr},${g},${b})`)
            }
            return {
                labels: label,
                datasets: [{
                    label: "",
                    data: data,
                    backgroundColor: bgCol,
                    borderColor: bcCol,
                    borderWidth: 1
                }]
            }
        }
        chartOptions: {
            return {
                maintainAspectRatio: false,
                title: {
                    display: true,
                    text: '及格率'
                },
                tooltips: {
                    mode: 'index',
                    intersect: false
                },
                scales: {
                    yAxes : [{
                        ticks : {
                            max : 100,
                            min : 0
                        }
                    }]
                }
            }
        }
    }
}
