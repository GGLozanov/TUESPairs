import React from 'react';
import { render } from '@testing-library/react';
import UserCard from '../../../constants/user_card';

test('User card render parameters', () => {
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
    
    const user = {
        photoURL: null,
        username: 'example',
        isTeacher: false,
        tags: tags,
    };

    const container = render(
        <UserCard user={user} />
    );

    const defaultImage = container.getByTestId('default-image');

    expect(defaultImage.src).toBe("https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png")
})