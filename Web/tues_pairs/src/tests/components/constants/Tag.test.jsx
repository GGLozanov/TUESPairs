import React from 'react';
import { render } from '@testing-library/react';
import TagListView from '../../../constants/tag';

test('Tag component render parameters', () => {
    const tags = [{
        name: 'Python',
        color: '#00618a'
    }, {
        name: 'SQL',
        color: '#db2828'
    }, {
        name: 'Kotlin',
        color: '#db2828'
    }];

    const container = render(
        <TagListView tags={tags}/>
    );

    tags.forEach(tag =>{
      let containerTag = container.findByTestId(tag.name);
      let tagLocally = container.findByTestId(tag.name);
      expect(containerTag).toStrictEqual(tagLocally);
    })
});