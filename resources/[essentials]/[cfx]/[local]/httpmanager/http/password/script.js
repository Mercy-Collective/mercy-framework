function generateHash() {
	let password = document.getElementById('input').value;

	fetch('generate-hash', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({password: password})
	}).then(resp => resp.json()).then(resp => {
		document.getElementById('output').value = resp.hash;
	});
}
