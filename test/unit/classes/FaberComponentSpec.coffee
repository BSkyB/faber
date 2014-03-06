describe 'FaberComponent: ', ->
  it 'should initialise element component correctly', ->
    elementComp = new FaberComponent
      name: 'Base component'
      type: 'element'
      template: 'template.html'

    elementNestableComp = new FaberComponent
      name: 'Base component'
      type: 'element'
      template: 'template.html'
      nestable: true

    expect(elementComp.name).toBe 'Base component'
    expect(elementComp.type).toBe 'element'
    expect(elementComp.template).toBe 'template.html'
    expect(elementComp.nestable).toBe false

    expect(elementNestableComp.name).toBe 'Base component'
    expect(elementNestableComp.type).toBe 'element'
    expect(elementNestableComp.template).toBe 'template.html'
    expect(elementNestableComp.nestable).toBe false

  it 'should initialise group component correctly', ->
    groupComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'

    groupNotNestableComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'
      nestable: false

    groupNestableComp = new FaberComponent
      name: 'Base component'
      type: 'group'
      template: 'template.html'
      nestable: true

    expect(groupComp.name).toBe 'Base component'
    expect(groupComp.type).toBe 'group'
    expect(groupComp.template).toBe 'template.html'
    expect(groupComp.nestable).toBe true

    expect(groupNotNestableComp.name).toBe 'Base component'
    expect(groupNotNestableComp.type).toBe 'group'
    expect(groupNotNestableComp.template).toBe 'template.html'
    expect(groupNotNestableComp.nestable).toBe false

    expect(groupNestableComp.name).toBe 'Base component'
    expect(groupNestableComp.type).toBe 'group'
    expect(groupNestableComp.template).toBe 'template.html'
    expect(groupNestableComp.nestable).toBe true