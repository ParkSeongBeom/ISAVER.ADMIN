/**
 * Multi Bar Chart
 * https://observablehq.com/@dovinmu/multi-valued-bar-chart
 *
 * @author psb
 * @type {Function}
 */
var MultiBar = (
    function(options){
        let _chartList = {};
        let _options = {};
        let _axisData = [];
        let _width = 500, _height = 150;
        let _margin = {top: 20, right: 0, bottom: 30, left: 40};
        let _max = 10;
        let _x, _y, _xAxis, _yAxis;
        let _color = {
            'pre' : '#ff6565'
            ,'today' : '#08b558'
        };

        /**
         * init
         * @author psb
         */
        let init = function(options){
            for(var index in options){
                if(_options.hasOwnProperty(index)){
                    _options[index] = options[index];
                }
            }
            setting();
        };

        var setting = function(){
            for(var i=0; i<=23; i++){
                _axisData.push({'name' : i,'values' : {'pre':0,'today':0}});
            }
            _x = d3.scaleBand()
                .domain(_axisData.map(d => d.name))
                .range([_margin.left, _width - _margin.right])
                .padding(0.2);

            _xAxis = g => g
                .attr("transform", `translate(0,${_height - _margin.bottom})`)
                .call(d3.axisBottom(_x)
                    .tickSizeOuter(0));

            _y = d3.scaleLinear()
                .domain([0, _max]).nice()
                .range([_height - _margin.bottom, _margin.top]);

            _yAxis = g => g
                .attr("transform", `translate(${_margin.left},0)`)
                .call(d3.axisLeft(_y).ticks(5))
                .call(g => g.select(".domain").remove());
        };

        this.setElement = function(parent) {
            let chartEl = parent.find("div[name='barChart']");
            chartEl.find("svg").remove();
            const svg = d3.create("svg").attr('viewBox', '0 0 '+_width+' '+_height);
            svg.append("g")
                .attr("class", "bars");
            svg.append("g")
                .attr("class", "xAxis")
                .call(_xAxis);
            svg.append("g")
                .attr("class", "yAxis")
                .call(_yAxis);
            chartEl.append(svg.node());

            let letters = ['pre','today'];
            update(svg);
            let uuid = uuid32();
            _chartList[uuid] = {
                'node' : svg.node()
                ,'letters' : letters
                ,'svg' : svg
            };
            return uuid;
        };

        var max = function(data, letters){
            return d3.max(data, function(e) {
                var retVal = 0;
                for(var key in letters){
                    if(retVal < e['values'][letters[key]]){
                        retVal = e['values'][letters[key]];
                    }
                }
                return retVal;
            });
        };

        var update = function(svg, data, letters){
            svg.selectAll('.bar-container').selectAll("rect").remove();

            var newMaxY = data!=null&&letters!=null?max(data, letters):0;
            if(newMaxY > _max){
                _y.domain([0,newMaxY]).nice();
            }else{
                _y.domain([0,_max]).nice();
            }
            svg.selectAll(".xAxis")
                .call(_xAxis);
            svg.selectAll(".yAxis")
                .call(_yAxis);

            if(data!=null && letters!=null){
                let xBars = d3.scaleBand()
                    .domain(letters)
                    .range([0, _x.bandwidth()])
                    .padding(0);

                svg.selectAll(".bars")
                    .selectAll("g").data(data).enter()
                    .append("g")
                    .attr("x", d => _x(d.name))
                    .attr("y", d => _y(0))
                    .attr("class", "bar-container")
                    .attr("fill", "white")
                    .attr("id", d => d.name);

                for(var key in letters){
                    svg.selectAll('.bar-container')
                        .append("rect")
                        .attr("id", d => letters[key] + d.name)
                        .attr("x", d => _x(d.name) + xBars(letters[key]))
                        .attr("y", d => _y(d.values[letters[key]]))
                        .attr("height", d => _y(0) - _y(d.values[letters[key]]))
                        .attr("width", _x.bandwidth() / letters.length)
                        .attr("fill", _color[letters[key]]);
                }
            }
        };

        this.setValue = function(uuid,chartData){
            if(_chartList[uuid]==null){
                console.error("[MultiBar] uuid is null or not found - "+uuid);
                return false;
            }

            let data = [];
            for(var index in chartData){
                let values = {};

                for(var i in chartData[index]){
                    values[i] = 0;
                    for(var k in chartData[index][i]){
                        values[i]+=chartData[index][i][k];
                    }
                }
                data.push({
                    'name' : index
                    ,'values' : values
                })
            }
            update(_chartList[uuid]['svg'], data, _chartList[uuid]['letters']);
        };

        init(options);
    }
);