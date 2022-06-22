import { useState } from 'react';
import Card from './shared/Card';
import Button from './shared/Button';
import RatingSelect from './RatingSelect';

// Input field for adding new review, when the review is added the field is cleaned up
function FeedbackForm({handleAdd}) {
    const [text, setText] = useState('');
    const [rating, setRating] = useState(10);
    const [btnDisabled, setBtnDisabled] = useState(true);
    const [message, setMessage] = useState('');

    const handleTextChange = ({ target: { value } }) => {
        if (value === '') {
            setBtnDisabled(true)
            setMessage(null)
        } else if (value !== '' && value.trim().length < 4) {
            setBtnDisabled(true)
            setMessage('Text must be at least 4 characters')
        } else {
            setBtnDisabled(false)
            setMessage(null)
        };

        setText(value)
    };

    const handleSubmit = (e) => {
        e.preventDefault()
        if (text.trim().length > 3) {
            const newFeedback = {
                text,
                rating
            }

            handleAdd(newFeedback)
            // Reset to default state after submission
            setText('')
        }
    };

    return (
        <Card>
            <form onSubmit={handleSubmit}>
                <h2>How would you rate your service with us?</h2>
                <RatingSelect select={setRating} selected={rating} />
                <div className='input-group'>
                    <input
                        onChange={handleTextChange}
                        type='text'
                        placeholder='Write a review'
                        value={text}
                    />
                    <Button type='submit' isDisabled={btnDisabled}>Send</Button>
                </div>

                {message && <div className='message'>{message}</div>}
            </form>
        </Card>
    )
}

export default FeedbackForm