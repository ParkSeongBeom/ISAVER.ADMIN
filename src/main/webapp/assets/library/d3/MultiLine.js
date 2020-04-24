/**
 * Multi Line Chart
 * https://observablehq.com/@m-marianne/1-le-crash-de-2008-mythe-ou-realite-la-preuve-par-les-chiffres
 *
 * @author psb
 * @type {Function}
 */
var MultiLine = (
    function(labelList, options){
        let _chartList = {};
        let _options = {
            'width' : 500
            ,'height' : 150
            ,'max' : 10
        };
        let _axisData = [];
        let _margin = {top: 20, right: 0, bottom: 30, left: 50};
        let _x, _y, _xAxis, _yAxis;

        /**
         * init
         * @author psb
         */
        let init = function(labelList, options){
            if(labelList!=null){
                _axisData = labelList;
            }else{
                for(var i=0; i<=23; i++){
                    _axisData.push({'date' : i,'cnt' : 0});
                }
            }

            for(var index in options){
                if(_options.hasOwnProperty(index)){
                    _options[index] = options[index];
                }
            }
            _x = d3.scaleBand()
                .domain(_axisData.map(d => d.date))
                .range([_margin.left, _options['width'] - _margin.right])
                .padding(0.2);

            _xAxis = g => g
                .attr("fill", "black")
                .attr("transform", `translate(0,${_options['height'] - _margin.bottom})`)
                .call(d3.axisBottom(_x)
                    .tickSizeOuter(0));

            _y = d3.scaleLinear()
                .domain([0, _options['max']]).nice()
                .range([_options['height'] - _margin.bottom, _margin.top]);

            _yAxis = g => g
                .attr("fill", "black")
                .attr("transform", `translate(${_margin.left},0)`)
                .call(d3.axisLeft(_y).ticks(5))
                .call(g => g.select(".domain").remove());
        };

        this.setElement = function(parent) {
            let chartEl = parent.find("div[name='lineChart']");
            chartEl.find("svg").remove();
            const svg = d3.create("svg").attr('viewBox', '0 0 '+_options['width']+' '+_options['height']);
            svg.append("g")
                .attr("class", "lines");
            svg.append("g")
                .attr("class", "xAxis")
                .call(_xAxis);
            svg.append("g")
                .attr("class", "yAxis")
                .call(_yAxis);
            chartEl.append(svg.node());

            update(svg, parent);

            let uuid = uuid32();
            _chartList[uuid] = {
                'node' : svg.node()
                ,'svg' : svg
                ,'parent' : parent
            };
            return uuid;
        };

        this.getChart = function(uuid) {
            return _chartList[uuid];
        };

        var max = function(data){
            return d3.max(data, function(e) {
                return d3.max(e.values, function(f) {
                    return f.cnt;
                });
            });
        };

        var update = function(svg, parent, data){
            svg.selectAll(".lines").selectAll("path").remove();
            let fenceTitleEl = parent.find("div[name='fenceTitle']");
            fenceTitleEl.empty();

            var newMaxY = data!=null?max(data):0;
            if(newMaxY > _options['max']){
                _y.domain([0,newMaxY]).nice();
            }else{
                _y.domain([0,_options['max']]).nice();
            }
            svg.selectAll(".xAxis")
                .call(_xAxis);
            svg.selectAll(".yAxis")
                .call(_yAxis);


            if(data!=null){
                /**
                 * Compute & draw chart line
                 */
                //const line = d3.line()
                //    .x(d => _x(d.date))
                //    .y(d => _y(d.cnt));

                const area = d3.area()
                    .x(d => _x(d.date))
                    .y0(_options['height'] - _margin.bottom)
                    .y1(d => _y(d.cnt))
                    .curve(d3.curveMonotoneX);

                for(var i in data){
                    fenceTitleEl.append(
                        $("<span/>",{class:"line_contents_"+i}).text(data[i]['name'])
                    );

                    //svg.selectAll(".lines")
                    //    .append('path')
                    //    .datum(d => data[i]['values'])
                    //    .attr('id', 'line')
                    //    .attr('d', line)
                    //    .attr("class", "line_contents_"+i);

                    //svg.selectAll(".lines")
                    //    .append('path')
                    //    .datum(d => data[i]['values'])
                    //    .attr('id', 'area')
                    //    .attr('d', area)
                    //    .attr("class", "line_area_"+i);

                    svg.selectAll(".lines")
                        .append('path')
                        .datum(d => data[i]['values'])
                        .attr('d', area)
                        .attr("class", "path-color line_contents_"+i);
                }
            }
        };

        var testData = function(){
            let data = [];
            for(var i=0; i<5; i++){
                let fenceData = {
                    'id' : i
                    ,'name' : 'Zone'+i
                    ,'values' : []
                };
                for(var index=0; index<24; index++){
                    fenceData['values'].push({
                        'date' : index
                        ,'cnt' : Number(Math.random()*1000)+1
                    })
                }
                data.push(fenceData);
            }
            return data;
        };

        this.setValue = function(uuid, data){
            if(_chartList[uuid]==null){
                console.error("[MultiBar] uuid is null or not found - "+uuid);
                return false;
            }

            update(_chartList[uuid]['svg'], _chartList[uuid]['parent'], data);
            //update(_chartList[uuid]['svg'], _chartList[uuid]['parent'], testData());
        };

        init(labelList, options);
    }
);