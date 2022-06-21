import { useState } from 'react';

// Rating selector (from 1 to 10, radio type)
function RatingSelect({select}) {
    const [selected, setSelected] = useState(10);

    const handleChange = (e) => {
        setSelected(+e.currentTarget.value)
        select(+e.currentTarget.value)
    }

    return (
        <div>

        </div>
        )
}

export default RatingSelect