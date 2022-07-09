import spinner from './assets/spinner.gif';

function Spinner() {

    return (

        <div style={{ display: 'flex', justifyContent: 'center' }}>
            <img
                width={180}
                src={spinner}
                alt='Loading...'
            />
        </div>
        )
}

export default Spinner