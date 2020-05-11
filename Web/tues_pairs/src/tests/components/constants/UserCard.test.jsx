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
        gpa: 5.32,
        tags: tags,
    };

    const container = render(
        <UserCard user={user} />
    );

    const defaultImage = container.getByTestId('default-image');
    const username = container.getByTestId('username');
    const student = container.getByTestId('student');
    const gpa = container.getByTestId('gpa');

    expect(defaultImage.src).toBe("https://x-treme.com.mt/wp-content/uploads/2014/01/default-team-member.png");

    let expected = container.getByText(user.username);
    expect(expected).toBe(username);
    expected = container.getByText('Student');
    expect(expected).toBe(student);
    expected = container.getByText('GPA:');
    expect(expected).toBe(gpa);
})