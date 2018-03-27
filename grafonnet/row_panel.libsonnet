{
    new(
        collapse=false,
        gridPos={},
        repeat=null,
        title='Dashboard Row',
    ):: {
        collapsed: collapse,
        gridPos: gridPos,
        panels: [],
        repeat: repeat,
        title: title,
        type: 'row',
        addPanels(panels):: self {
            panels+: panels,
        },
        //addPanel(panel, gridPos={}):: self {
        addPanel(panel):: self {
            //panels+: [panel { gridPos: gridPos }],
            panels+: [panel],
        },
    },
}
