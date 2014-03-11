describe 'FaberComponent: ', ->
  it 'should initialise element component correctly', ->
    elementComp = new FaberComponent
      name: 'Base component'
      type: 'element'
      template: 'template.html'

    topLevelOnlyComp = new FaberComponent
      name: 'Base component'
      type: 'element'
      template: 'template.html'
      topLevelOnly: true

    expect(elementComp.name).toBe 'Base component'
    expect(elementComp.type).toBe 'element'
    expect(elementComp.template).toBe 'template.html'
    expect(elementComp.topLevelOnly).toBe false

    expect(topLevelOnlyComp.name).toBe 'Base component'
    expect(topLevelOnlyComp.type).toBe 'element'
    expect(topLevelOnlyComp.template).toBe 'template.html'
    expect(topLevelOnlyComp.topLevelOnly).toBe false

  it 'should initialise group component correctly', ->
    groupComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'

    groupTopLevelOnlyComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'
      topLevelOnly: false

    groupAnyLevelComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'
      topLevelOnly: true

    expect(groupComp.name).toBe 'Base component'
    expect(groupComp.type).toBe 'group'
    expect(groupComp.template).toBe 'template.html'
    expect(groupComp.topLevelOnly).toBe true

    expect(groupTopLevelOnlyComp.name).toBe 'Base component'
    expect(groupTopLevelOnlyComp.type).toBe 'group'
    expect(groupTopLevelOnlyComp.template).toBe 'template.html'
    expect(groupTopLevelOnlyComp.topLevelOnly).toBe false

    expect(groupAnyLevelComp.name).toBe 'Base component'
    expect(groupAnyLevelComp.type).toBe 'group'
    expect(groupAnyLevelComp.template).toBe 'template.html'
    expect(groupAnyLevelComp.topLevelOnly).toBe true