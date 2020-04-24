/**
 * Speed Meter Chart
 * https://observablehq.com/@yvescavalcanti/pointer
 *
 * @author psb
 * @type {Function}
 */
var SpeedMeter = (
    function(options){
        let _chartList = {};
        let _options = {
            range : [0, 150]
            ,format : 'km/h'
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
        };

        let dropShadow = function(selection){
            let defs, filter;
            if(selection.select('defs').empty()){
                defs = selection.append('defs');
            }
            filter = defs.append('filter').attr('id', 'fDrop').attr('x', 0).attr('y', 0)
                .attr('width', '200%').attr('height','100%');
            filter.append('feDropShadow').attr('stdDeviation', '0.2')
                .attr('dx', 0.3).attr('dy', 0.4);
        };

        let arcs = (data, innerRadius, outerRadius) => {
            let aG = d3.arc().startAngle(el => el[0]).endAngle(el => el[1])
                .innerRadius(innerRadius).outerRadius(outerRadius);
            let scale = d3.scaleLinear().domain([d3.min(data),d3.max(data)]).range([-Math.PI/2, Math.PI/2]);
            return data.reduce((a,b,i, arr) => {
                    if(i === 0)
                        return a;
                    else{
                        a.push(aG([scale(arr[i-1]), scale(b)]));
                        return a;
                    }
                }
                , []);
        };

        this.setElement = function(parent) {
            var width = 150, height = 150, margin = 5, endAngle = Math.PI/2, startAngle = -endAngle, radius= width/2 - (margin*2);
            var crOuterRadius = radius, crInnerRadius = crOuterRadius*0.95;
            var gWidth = 20, gOuterRadius = crInnerRadius * 0.95, gInnerRadius = gOuterRadius - gWidth;
            var neddleTop = crOuterRadius + 2;
            const svg = d3.create("svg").attr('viewBox', '0 0 '+width+' '+height*0.6);
            const g = svg.append('g').attr('transform', 'translate(' + width/2 + ',' + (height/2) + ')');
            g.call(dropShadow);
            let scale = d3.scaleLinear().range([startAngle, endAngle]).domain([d3.min(_options['range']), d3.max(_options['range'])]);
            let arco = d3.arc().innerRadius(gInnerRadius).outerRadius(gOuterRadius)
                .startAngle(el => el[0]).endAngle(el => el[1]);
            let backarc = g.append('path').attr('d', arco([startAngle, endAngle])).attr('class','backarc');
            let referencia = g.append('path').attr('class','reference')
                .attr('d', arco([-Math.PI/2,scale(0)]));
            let setores = arcs(_options['range'],crInnerRadius, crOuterRadius);
            g.selectAll('path.setores').data(setores).enter().append('path').attr('class','setores');
            let neddle = g.append('path').attr('class', 'neddle')
                .attr('filter', 'url(#fDrop)')
                .attr('d', d3.line()([[-2, -30],[2,-30],[0,-neddleTop],[-2, -30]]))
                .attr('transform', 'rotate(-90)');
            let text = g.append('text').attr('x', 0).attr('y', -5)
                .attr('class', 'gauge-texto center-value').attr('text-anchor','middle')
                .text(0);

            let uuid = uuid32();
            parent.append(svg.node());
            _chartList[uuid] = {
                'node' : svg.node()
                ,'neddle' : neddle
                ,'text' : text
                ,'referencia' : referencia
                ,'scale' : scale
                ,'arco' : arco
            };
            return uuid;
        };

        this.setValue = function(uuid,value){
            if(_chartList[uuid]==null){
                console.error("[SpeedMeter] uuid is null or not found - "+uuid);
                return false;
            }
            _chartList[uuid]['referencia'].attr('d', _chartList[uuid]['arco']([-Math.PI/2,_chartList[uuid]['scale'](value)]));
            _chartList[uuid]['neddle'].transition().duration(1000)
                .attr('transform', 'rotate('+(180*(value/_options['range'][_options['range'].length-1])-90)+')');
            _chartList[uuid]['text'].text(value + _options['format']);
        };

        init(options);
    }
);